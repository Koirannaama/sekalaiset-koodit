function Hello(props) {
  let greeting = props.name ? ("Hello, " + props.name + "!") : "Hello!";
  return <h1>{greeting}</h1>;
}

function NameInput(props) {
  return <input type="text" onInput={props.storeName}/>;
}

function LetterAmount(props) {
  let len = props.string.length;
  let text = "Your name has " + len + " letters.";
  return <span>{text}</span>
}

class Elem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {name: ""};
  }

  updateName = (e) => {
    this.setState({name: e.target.value});
  }

  render() {
    let letterAmount = this.state.name.length > 0 ? <LetterAmount string={this.state.name}/> : null;
    return (
      <div>
        <NameInput storeName={this.updateName}/>
        <Hello name={this.state.name}/>
        {letterAmount}
      </div>
    );
  }
}

ReactDOM.render(
  <Elem ></Elem>,
  document.getElementById('root')
);
