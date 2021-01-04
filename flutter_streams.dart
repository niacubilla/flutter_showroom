import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ItemModel {
	final StreamController<int> _itemsController = StreamController<int>.broadcast();
	final StreamController<int> _receiverController = StreamController<int>.broadcast();
	StreamSubscription<int> _itemsSubscription;
	Stream<int> get outItems => _itemsController.stream;
	Sink<int> get inItems => _itemsController.sink;

	void dispose() {
		_itemsController.close();
		_receiverController.close();
	}

  	stream() async {
    	_itemsSubscription = _receiverController.stream.listen((value) {
			inItems.add(value);
			print("_itemsSubscription:" + value.toString());
		});

		while ( true ) {
			await Future.delayed(Duration(seconds: 1));
			var value = Random().nextInt(20000);
			_receiverController.sink.add(value);
			print("_receiverController:" + value.toString());
		}
	}

	pause() {
		_itemsSubscription.pause();
	}

	resume() {
		_itemsSubscription.resume();
	}

	cancel() {
		_itemsSubscription.cancel();
		_itemsController.close();
	}
}

class StreamScreen extends StatelessWidget {
	final _itemModel = ItemModel();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
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
								snapshot.data.toString(),
								style: TextStyle(fontSize: 50),
							);
							},
						),
						SizedBox(height: 20),
						PauseButton(
							itemModel: _itemModel,
						),
						SizedBox(height: 20),
						ResumeButton(
							itemModel: _itemModel,
						),
						SizedBox(height: 20),
						CancelButton(
							itemModel: _itemModel,
						),
						SizedBox(height: 20),
						StartButton(
							itemModel: _itemModel,
						),
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
			children: <Widget>[
				Text("Esperando stream"),
				SizedBox(height: 20),
				CircularProgressIndicator()
			]
		);
	}
}

class PauseButton extends StatelessWidget {
	final ItemModel itemModel;

	PauseButton({this.itemModel});

	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.orange[300],
			onPressed: () => itemModel.pause(),
			child: Text("Pause stream"),
		);
	}
}

class ResumeButton extends StatelessWidget {
	final ItemModel itemModel;

	ResumeButton({this.itemModel});

	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.blue[300],
			onPressed: () => itemModel.resume(),
			child: Text("Resume stream"),
		);
	}
}

class CancelButton extends StatelessWidget {
	final ItemModel itemModel;

	CancelButton({this.itemModel});

	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.red[300],
			onPressed: () => itemModel.cancel(),
			child: Text("Cancel stream"),
		);
	}
}

class StartButton extends StatelessWidget {
	final ItemModel itemModel;

	StartButton({this.itemModel});

	@override
	Widget build(BuildContext context) {
		return RaisedButton(
			color: Colors.green[300],
			onPressed: () => itemModel.stream(),
			child: Text("Start stream"),
		);
	}
}
