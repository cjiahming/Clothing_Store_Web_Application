class Sales extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = `
        <head>
		<link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
        </head>
            -- Operations --<br/><p style="letter-spacing: 0.5rem;color: #7F6000;font-size: 23px;">Sales</p>
       

        `;
    }
}
customElements.define('sales-header', Sales);


