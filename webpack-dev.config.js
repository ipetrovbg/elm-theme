const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    mode: 'development',
    module: {
        rules: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                loader: 'file-loader?name=[name].[ext]'
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: {
                    loader: 'elm-webpack-loader?verbose=true&warn=true',
                    options: {
                        optimize: false
                        , runtimeOptions: ['-A128M', '-H128M', '-n8m']
                        , forceWatch: true
                        , debug: true
                    }
                }
            },
            {
                test: /\.css$/i,
                use: [
                    {loader: MiniCssExtractPlugin.loader},
                    {loader: 'css-loader'}
                ]
            },
        ]
        , noParse: /\.elm$/
    },
    output: {
        path: path.resolve(__dirname, 'public'),
    },
    devServer: {
        inline: true,
        stats: {colors: true},
        historyApiFallback: true,
    },
    plugins: [
        new MiniCssExtractPlugin()
    ]
};
