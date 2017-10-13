Q.Node.prototype.type = "Node";
Q.Text.prototype.type = "Text";
Q.Group.prototype.type = "Group";
Q.Edge.prototype.type = "Edge";

var graph;
var nodes = [];
$(function(){
    Q.addCSSRule(".maximize", "margin: 0px !important;position: fixed !important;top: 0px;bottom: 0px;right: 0px;left: 0px;z-index: 1030;height: auto !important; width: auto !important;");
    graph = new Q.Graph("canvas");



    function ImageBackground(graph, options) {
        this.graph = graph;
       graph.delayedRendering = false;
        graph.background = this;
        graph.onPropertyChange('transform', this.update.bind(this));

        this.canvas = Q.createCanvas(graph.width, graph.height);
        this.canvas.style.position = 'absolute';
        this.canvas.style.top = '0px';
        this.canvas.style['-webkit-user-select'] = 'none';
        this.canvas.style['-webkit-tap-highlight-color'] = 'rgba(0, 0, 0, 0)';

        graph.canvasPanel.insertBefore(this.canvas, graph.canvasPanel.firstChild);

        this._options = options;

        this.graph._getOverviewScaleInfo = function () {
            var elementBounds = this.bounds;
            if (this.background && this.background.bounds) {
                elementBounds = elementBounds.union(this.background.bounds);
            }
            if (!elementBounds.isEmpty()) {
                var xScale = this.width / elementBounds.width;
                var yScale = this.height / elementBounds.height;
                var scale = Math.max(xScale, yScale);
                scale = Math.max(this.minScale, Math.min(this.maxScale, scale));
                return {scale: scale, cx: elementBounds.cx, cy: elementBounds.cy};
            }
        }
        this.graph.zoomToOverview = function (byAnimate, maxScale) {
            return this.callLater(function () {
                var scaleInfo = this._getOverviewScaleInfo();
                if (scaleInfo) {
                    if (maxScale) {
                        scaleInfo.scale = Math.min(scaleInfo.scale, maxScale);
                    }
                    this.centerTo(scaleInfo.cx, scaleInfo.cy, scaleInfo.scale, false);
                }
            }, this);
        }
    }

    ImageBackground.prototype = {
        update: function () {
            if (!this._imageTarget) {
                return;
            }
            //Q.callLater(function () {
            var image = this._imageTarget;
            var graph = this.graph;
            var canvas = this.canvas;

            canvas.width = graph.width;//clear canvas
            canvas.height = graph.height;//clear canvas

            var g = canvas.g;

            g.save();
            g.translate(graph.tx, graph.ty);
            g.scale(graph.scale, graph.scale);

            g.drawImage(image, 0, 0, image.width, image.height);

            g.restore();
            //}.bind(this));
        },
        _doTransform: function (g, scale, bounds) {
            g.translate(-scale * bounds.x, -scale * bounds.y);
            g.scale(scale, scale);
        },
        _onImageLoad: function (evt) {
            if (evt.target != this._imageTarget) {
                return;
            }
            this.bounds = new Q.Rect(0, 0, this._imageTarget.width, this._imageTarget.height);
            this.update();
            if (this._options && this._options.onload instanceof Function) {
                this._options.onload(this);
            }
        }
    }

    Object.defineProperties(ImageBackground.prototype, {
        image: {
            get: function () {
                return this._image;
            },
            set: function (v) {
                this._image = v;
                if (!v) {
                    this._imageTarget = null;
                    return;
                }
                var image = this._imageTarget = document.createElement('img');
                image.src = this._image;
                image.onload = this._onImageLoad.bind(this);
            }
        }
    })
    var background = new ImageBackground(graph, {
        onload: function () {
           //loadDatas();
            initDatas();
           graph.limitedBounds = background.bounds;
            graph.zoomToOverview();
        }
    });

    loadbackgroundIMg(background);

    graph.ondblclick = function(evt) {
        var node = graph.getElementByMouseEvent(evt);
        if(node){
            $('#bldname').val("");
            $('#bldid').val("");
            layer.open({
                type: 2,
                title: '设置楼栋属性',
                shadeClose: false,
                shade: 0.8,
                area: ['300px', '200px'],
                content: 'edit.jsp?projid='+$('#projid').val()+'&bldname='+node.get("bldid"),
                closeBtn: 0,
                end : function(){
                    node.name=$('#bldname').val();
                    node.set("bldid",$('#bldid').val());
                    //console.log(node);
                }
            });
        }
    }


    var styles = {};
    styles[Q.Styles.SELECTION_COLOR] = "#0F0";
    graph.styles = styles;

    graph.originAtCenter = false;
    graph.editable = true;

    graph.onElementCreated = function (element, evt) {
        if (element instanceof Q.Edge) {
            var v = prompt("连线粗度");
            v = parseInt(v);
            if(v){
                element.setStyle(Q.Styles.EDGE_WIDTH, v);
            }else{
                graph.removeElement(element);
            }
            if(element.edgeType && element.edgeType != Q.Consts.EDGE_TYPE_DEFAULT){
                element.setStyle(Q.Styles.EDGE_BUNDLE, false);
            }
            return;
        }
        if (element instanceof Q.Text) {
            element.setStyle(Styles.LABEL_BACKGROUND_COLOR, "#2898E0");
            element.setStyle(Styles.LABEL_COLOR, "#FFF");
            element.setStyle(Styles.LABEL_PADDING, new Q.Insets(3, 5));
            return;
        }
    }

    graph.onLabelEdit = function(element, label, text, elementUI){
        if(!text){
            return false;
        }
        element.name = text;
        //此处调用后台保存
    }

    appendInteractionMenu(graph);

    initToolbar();
    initToolbox();


//监听面板调整大小事件，同步graph大小
    $('#center_panel').panel({
        onResize: function (w, h) {
            graph.updateViewport();
        }
    });

});

function ensureVisible(node){
    var bounds = graph.getUIBounds(node);
    var viewportBounds = graph.viewportBounds;
    if(!viewportBounds.contains(bounds)){
        graph.sendToTop(node);
        graph.centerTo(node.x, node.y);
    }
}

function setInteractionMode(evt, info){
    graph.interactionMode = info.value;
    currentInteractionMode = info.value;
    if(info.value == Q.Consts.INTERACTION_MODE_CREATE_EDGE){
        graph.edgeUIClass = info.edgeUIClass;
        graph.edgeType = info.edgeType;
    }
}
function initToolbar(){
    var toolbar = document.getElementById("toolbar");
    var buttons = {
        interactionModes:[{name: "默认模式", value:Q.Consts.INTERACTION_MODE_DEFAULT, selected: true, icon:'images/default_icon.png', action: setInteractionMode},
            {name: '框选模式', value:Q.Consts.INTERACTION_MODE_SELECTION, icon:'images/rectangle_selection_icon.png', action: setInteractionMode},
            {name: '浏览模式', value:Q.Consts.INTERACTION_MODE_VIEW, icon:'images/pan_icon.png', action: setInteractionMode}],
        zoom: [{name: "放大", icon:"images/zoomin_icon.png", action: function(){graph.zoomIn()}},
            {name: "缩小", icon:"images/zoomout_icon.png", action: function(){graph.zoomOut()}},
            {name: "1:1", action: function(){graph.scale = 1;}},
            {name: '纵览', icon:'images/overview_icon.png', action: function(){this.zoomToOverview()}}],
        find: {name: '保存', action: function(evt, info){
            //获取项目id
            var projid=$('#projid').val();
            console.log("projid:"+projid);
            var i=0;
            //遍历节点获取节点坐标跟楼栋信息
            var bldinfos="{\"data\":[";
            //console.log(graph);
            graph.forEach(function(e){
                if(e instanceof Q.Node){
                    //拼接json串
                    var nodeinfo="{\"bldid\":\""+e.get("bldid")+"\",\"bldname\":\""+e.name+"\",\"bldx\":\""+e.x+"\",\"bldy\":\""+e.y+"\"}";
                    if(i<graph.count-1)
                        nodeinfo=nodeinfo+",";
                    bldinfos=bldinfos+nodeinfo;
                    i++;
                }
            }, graph);
            bldinfos=bldinfos+"]}";
            console.log(bldinfos);
            //保存(修改)楼栋信息
            $.ajax ({
                url: "/eac-base/servlet/structure.action?method=saveOrUpdBldXY",
                datatype: "json",
                //传送请求数据
                type: "GET",
                contentType: "application/json",
                data: {projid:projid,bldinfos:bldinfos},//中文乱码
                success: function (data) { //登录成功后返回的数据
                    console.log(data);
                    //根据返回值进行状态显示
                    if (data.flag == "1") {

                    }
                    layer.alert(data.msg);
                }, error: function(XMLHttpRequest, textStatus, errorThrown) {
                    layer.alert("error",errorThrown);
                }
            });
        }}
    };
    createToolBar(buttons, toolbar, graph, false, false);

}

function initToolbox(){
    var toolbox = document.getElementById("toolbox");

    createToolBar({},
        toolbox, graph,  "btn-group-vertical", false);
        createDNDImage(toolbox, "images/home_menu1.png", "请双击设置", {type: "Node", label: "请双击设置", image: "images/home_menu1.png"});
}
function getTreeIcon(d){
    return d instanceof Q.Edge ? "edge_icon" : "node_icon";
}
function syncDataTreeAndGraph(treeId, graph){
    treeId = "#" + treeId;
    graph.listChangeDispatcher.addListener(function(evt){
        var data = evt.data;
        switch (evt.kind) {
            case Q.ListEvent.KIND_ADD :
                var treeData = {data:[{id: data.id, text: data.name, iconCls: getTreeIcon(data)}]};
                $(treeId).tree('append', treeData);
                break;
            case Q.ListEvent.KIND_REMOVE :
                Q.forEach(data, function(node){
                    var node = $(treeId).tree('find', node.id);
                    if(node){
                        $(treeId).tree('remove', node.target);
                    }
                });
                break;
            case Q.ListEvent.KIND_CLEAR :
                break;
        }
    });
}

function syncSelectionTreeAndGraph(treeId, graph){
    treeId = "#" + treeId;
    var selectionAjdusting;
    graph.selectionChangeDispatcher.addListener(function(evt){
        if(selectionAjdusting){
            return;
        }
        selectionAjdusting = true;
        var selection = [];
        graph.selectionModel.forEach(function(node){
            var node = $(treeId).tree('find', node.id);
            if(node){
                selection.push(node.target);
            }
        });
        $(treeId).tree('select', selection);
        selectionAjdusting = false;
    });
    $(treeId).tree({onSelect: function(){
        if(selectionAjdusting){
            return;
        }
        selectionAjdusting = true;
        var selected = $(treeId).tree("getSelected");
        if(selected){
            var node = graph.getElement(selected.id);
            graph.selectionModel.set(node);
            if(node){
                ensureVisible(node);
            }
        }
        selectionAjdusting = false;
    }});
}

function initTopology(topoNodes,topoRelations)
{
    var map = {};
    for(var i=0;i<topoNodes.length;i++)
    {
        var node = topoNodes[i];
        var qNode = new Q.Node();
        qNode.name=node.name;
        qNode.location = new Q.Point(node.x,node.y);
        graph.graphModel.add(qNode);
        map[node.id] = qNode;
    }
    for(var i=0;i<topoNodes.length;i++)
    {
        var node = topoNodes[i];
        var parent = node.parent;
        if(parent){
            parent = map[parent];
            if(parent){
                map[node.id].parent = parent;
            }
        }
    }
    for(var i=0;i<topoRelations.length;i++)
    {
        var relation = topoRelations[i];
        var nodeFrom = map[relation.from];
        var nodeTo = map[relation.to];
        if(nodeFrom && nodeTo){
            var edge = graph.createEdge(nodeFrom, nodeTo);
            edge.info = relation;
        }
    }
}