require('UIColor,UIView,UILabel');
defineClass('NWViewController', {
    __demoTest: function() {
        var testArea = self.testArea();
        var tipLabel = testArea.viewWithTag(10000);
        tipLabel.setText("我是js线上修改");
        var color = UIColor.blueColor();
        testArea.setBackgroundColor(color);
    }
  })