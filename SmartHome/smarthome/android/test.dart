/* class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _turnOnAC() {
    setState(() {
      if (_powerColor == Colors.white) {
        _powerColor = Colors.red;
        _tempColor = Colors.lightBlueAccent;
      } else {
        _powerColor = Colors.white;
        _tempColor = Colors.grey.shade900;
      }
    });
  }

  void _tempUP() {
    setState(() {
      if (_powerColor == Colors.red) {
        _tempAC++;
        if (_tempAC >= 30) {
          _tempAC = 30;
        }
      }
    });
  }

  void _tempDowm() {
    setState(() {
      if (_powerColor == Colors.red) {
        _tempAC--;
        if (_tempAC <= 15) {
          _tempAC = 15;
        }
      }
    });
  }

  Color _powerColor = Colors.white;
  Color _tempColor = Colors.grey.shade900;
  Color _controllerColor = Colors.grey.shade900;
  int _tempAC = 20;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.black,
          title: Text('Klima'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Divider(
              color: _controllerColor,
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              alignment: Alignment.center,
              child: Text(
                '$_tempAC',
                style: TextStyle(fontSize: 40, color: _tempColor),
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: _controllerColor,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              padding: EdgeInsets.only(
                  top: size.height * 0.05, bottom: size.height * 0.05),
              width: size.width * 0.6,
              height: size.height * 0.4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: Material(
                          color: _controllerColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(Icons.add),
                            onTap: () {
                              _tempUP();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: Material(
                          color: _controllerColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(Icons.remove),
                            onTap: () {
                              _tempDowm();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 50,
                    width: 50,
                    child: Material(
                      color: _controllerColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.power_settings_new,
                          color: _powerColor,
                        ),
                        onTap: () {
                          _turnOnAC();
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
*/