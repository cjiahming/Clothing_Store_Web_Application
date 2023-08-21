/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

const Confirm = {
    open(options) {
        options = Object.assign({}, {
            title: '',
            message: '',
            okText: '&#10004;',
            cancelText: '&#10006;',
            onok: function () {},
            oncancel: function () {}
        }, options);

        const html = `<%@page import="Model.Domain.Product" %>
        <%
            Product[] product = (Product[]) session.getAttribute("prodList");
        %>
        <style>
        @import url('https://fonts.googleapis.com/css?family=Noto+Sans:400,700&display=swap');
        
.confirm {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6);
    padding: 10px;
    box-sizing: border-box;

    opacity: 0;
    animation-name: confirm---open;
    animation-duration: 0.2s;
    animation-fill-mode: forwards;

    display: flex;
    align-items: center;
    justify-content: center;
}

.confirm--close {
    animation-name: confirm---close;
}

.confirm__window {
    width: 100%;
    max-width: 600px;
    background: white;
    font-size: 14px;
    font-family: 'Noto Sans', sans-serif;
    border-radius: 5px;
    overflow: hidden;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);

    opacity: 0;
    transform: scale(0.75);
    animation-name: confirm__window---open;
    animation-duration: 0.2s;
    animation-fill-mode: forwards;
    animation-delay: 0.2s;
}

.confirm__titlebar,
.confirm__content,
.confirm__buttons {
    padding: 1.25em;
}

.confirm__titlebar {
    background: #F1EBDE;
    color: black;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.confirm__title {
    font-weight: bold;
    font-size: 1.1em;
}

.confirm__close {
    background: none;
    outline: none;
    border: none;
    transform: scale(2.5);
    color: #ffffff;
    transition: color 0.15s;
}

.confirm__close:hover {
    color: #ff0000;
    cursor: pointer;
}

.confirm__content {
    line-height: 1.8em;
}

.confirm__buttons {
    background: #eeeeee;
    display: flex;
    justify-content: flex-end;
}

.confirm__button {
    padding: 0.4em 0.8em;
    border: 2px solid #7F6000;
    border-radius: 50%;
    background: #7F6000;
    color: white;
    font-weight: bold;
    font-size: 1.1em;
    font-family: 'Noto Sans', sans-serif;
    margin-left: 0.6em;
    cursor: pointer;
    outline: none;
}

.confirm__button--fill {
    background: #7F6000;
    color: white;
}

.confirm__button:focus {
    box-shadow: 0 0 3px rgba(0, 0, 0, 0.5);
}

@keyframes confirm---open {
    from { opacity: 0 }
    to { opacity: 1 }
}

@keyframes confirm---close {
    from { opacity: 1 }
    to { opacity: 0 }
}

@keyframes confirm__window---open {
    to {
        opacity: 1;
        transform: scale(1);
    }
}
table#selectTable th, table#selectTable td {
  border:1px solid grey;
  border-collapse: collapse;
}

        </style>
            <div class="confirm">
                <div class="confirm__window">
                    <div class="confirm__titlebar">
                        <span class="confirm__title">${options.title}</span>
                        <button class="confirm__close">&times;</button>
                    </div>
                    <div class="confirm__content">
                    <table id="selectTable" style="width:100%">
                        <for (var i = 0; i < prodList.length; i++) {
                            <tr>
                          <td>16</td>
                          <td>14</td>
                          <td>10</td>
                        </tr>
        }
                        
                      </table>
                 </div>
                    <div class="confirm__buttons">
                        <button class="confirm__button confirm__button--ok confirm__button--fill">${options.okText}</button>
                        <button class="confirm__button confirm__button--cancel">${options.cancelText}</button>
                    </div>
                </div>
            </div>
        `;

        const template = document.createElement('template');
        template.innerHTML = html;

        // Elements
        const confirmEl = template.content.querySelector('.confirm');
        const btnClose = template.content.querySelector('.confirm__close');
        const btnOk = template.content.querySelector('.confirm__button--ok');
        const btnCancel = template.content.querySelector('.confirm__button--cancel');

        confirmEl.addEventListener('click', e => {
            if (e.target === confirmEl) {
                options.oncancel();
                this._close(confirmEl);
            }
        });

        btnOk.addEventListener('click', () => {
            options.onok();
            this._close(confirmEl);
        });

        [btnCancel, btnClose].forEach(el => {
            el.addEventListener('click', () => {
                options.oncancel();
                this._close(confirmEl);
            });
        });

        document.body.appendChild(template.content);
    },

    _close(confirmEl) {
        confirmEl.classList.add('confirm--close');

        confirmEl.addEventListener('animationend', () => {
            document.body.removeChild(confirmEl);
        });
    }
};
