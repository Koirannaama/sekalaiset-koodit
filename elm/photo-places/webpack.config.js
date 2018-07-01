var path = require("path");
const webpack = require('webpack');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: {
    app: [
      './js/elm.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader, 
          //'style-loader',
          'css-loader',
          //"sass-loader"
        ]
      },
      {
        test:    /\.html$/,
        exclude: [/node_modules/, /server/],
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/,  /\.html$/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/,
  },

  plugins: [
      new MiniCssExtractPlugin({
          filename: "[name].css",
          chunkFilename: "[id].css"
      })
  ],

  devServer: {
    inline: true,
    stats: { colors: true },
  },


};