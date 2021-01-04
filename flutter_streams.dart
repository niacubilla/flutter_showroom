import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ItemModel {
	final StreamController<int> _itemsController = StreamController<int>.broadcast();
	StreamSubscription<int> _itemsSubscription;
	Stream<int> get outItems => _itemsController.stream;
	Sink<int> get inItems => _itemsController.sink;

	void dispose() {
		_itemsController.close();
	}

	stream() async {
		while (true) {
			await Future.delayed(Duration(seconds: 1));
			var value = Random().nextInt(20000);
			inItems.add(value);

			_itemsSubscription = outItems.listen((value) {
				print(value);
			});
		}
	}

	pause() {
		//_itemsSubscription = outItems.listen((value) => print(value));
		_itemsSubscription.pause();
	}
	resume() {
		//_itemsSubscription = outItems.listen((value) => print(value));
		_itemsSubscription.resume();
	}
	cancel() {
		//_itemsSubscription = outItems.listen((value) => print(value));
		_itemsSubscription.cancel();
	}
}

class ShopScreen extends StatelessWidget {
	final _itemModel = ItemModel();
	
	@override
	Widget build(BuildContext context) {
		_itemModel.stream();
		return Scaffold(
			body: Center(
				child: Column(
				  	children: [
						StreamBuilder(
							stream: _itemModel.outItems,
							builder: (context, snapshot) {  
								if (!snapshot.hasData) {
									return LoadingWidget();
								}
								if (snapshot.connectionState == ConnectionState.done) {
									return Text("Fin del Stream :(");
								}
								return Text(
									snapshot.hasData ? snapshot.data.toString()
									: 'No data here',
									style: TextStyle(fontSize:50),
								);
							},
						),

						SizedBox(height:20),
						PauseButton(),

						SizedBox(height:20),
						ResumeButton(),

						SizedBox(height:20),
						CancelButton(),

						SizedBox(height:20),
						StartButton(),
					],
				)
			),
		);
	}
}

class LoadingWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget> [
				Text("Esperando stream"),
				SizedBox(height: 20),
				CircularProgressIndicator()
			]
		);
	}
}

class PauseButton extends StatelessWidget{
	final _itemModel = ItemModel();
	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.orange[300],
			onPressed: () => _itemModel.pause(),
			child: Text("Pause stream"),
		);
	}
}

class ResumeButton extends StatelessWidget{
	final _itemModel = ItemModel();
	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.blue[300],
			onPressed: () => _itemModel.resume(),
			child: Text("Resume stream"),
		);
	}
}

class CancelButton extends StatelessWidget{
	final _itemModel = ItemModel();
	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.red[300],
			onPressed: () => _itemModel.cancel(),
			child: Text("Cancel stream"),
		);
	}
}

class StartButton extends StatelessWidget{
	final _itemModel = ItemModel();
	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.green[300],
			onPressed: () => _itemModel.stream(),
			child: Text("Start stream"),
		);
	}
}
