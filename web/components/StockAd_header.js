class Stock extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = `
        <head>
		<link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        </head>
            -- Product Management --<br/><p style="letter-spacing: 0.5rem;color: #7F6000;font-size: 23px;">Stock Adjustment</p>
       

        `;
    }
}
customElements.define('stock-header', Stock);