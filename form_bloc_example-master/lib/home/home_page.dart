import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  type_Filter filterUsed;
  List<type_Filter> filter = <type_Filter>[
    const type_Filter(
        'Ninguno',
        Icon(
          Icons.not_interested,
          color: Colors.cyanAccent,
        )),
    const type_Filter(
        'Impar',
        Icon(
          Icons.filter_1,
          color: Colors.cyanAccent,
        )),
    const type_Filter(
        'Par',
        Icon(
          Icons.filter_2,
          color: Colors.cyanAccent,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users list"),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          BlocProvider(create: (context) => HomeBloc()..add(GetAllUsersEvent()),
          child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // para mostrar dialogos o snackbars
            if (state is ErrorState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
            }
          },
           builder: (context, state) {
             return DropdownButton<type_Filter>(
            hint: Text("Aplicar Filtro"),
            value: filterUsed,
            onChanged: (type_Filter Value) {
              //Aplicando la logica de los filtros a base del nombre en el menu
              setState(() { 
                filterUsed = Value;
                if(Value.name=="Par"){
                print("Filtro Par"); 
                BlocProvider.of<HomeBloc>(context).add(FilterUsersEvent(filterEven: true));
                if (state is ShowUsersState)
                setState(() {state.usersList;});

                }else if(Value.name=="Impar"){
                  print("Filtro Impar");
                  BlocProvider.of<HomeBloc>(context).add(FilterUsersEvent(filterEven: false));
                } else {
                  print("Sin filtro");
                  setState(() {
                    filterUsed=null;
                  });
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                }
              });
            },
            items: filter.map((type_Filter filtro) {
              return DropdownMenuItem<type_Filter>(
                value: filtro,
                child: Row(
                  children: <Widget>[
                    filtro.icon,
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      filtro.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
           }
          ),)
        ],
      ),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(GetAllUsersEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // para mostrar dialogos o snackbars
            if (state is ErrorState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
            }
          },
          builder: (context, state) {
            if (state is ShowUsersState) {
              return RefreshIndicator(
                //Done!:nombre del usuario, company name, street y phone | cambiar ListView.builder por ListView.separated
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: state.usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          "Id: ${state.usersList[index].id}| ${state.usersList[index].name}"),
                      subtitle: Text(
                          "Compañia: ${state.usersList[index].company.name} \n Calle: ${state.usersList[index].address.city}\n Telefono: ${state.usersList[index].phone}"),
                    );
                  },
                ),
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
              );
            } else if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: MaterialButton(
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
                child: Text("Cargar de nuevo"),
              ),
            );
          },
        ),
      ),
    );
  }
}

class type_Filter {
  const type_Filter(this.name, this.icon);
  final String name;
  final Icon icon;
}
