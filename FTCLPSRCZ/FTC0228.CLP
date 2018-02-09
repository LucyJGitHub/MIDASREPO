/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT RFT Unauthorised by Booking Branch')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0228   - Unauthorised RFT by Booking Branch              */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG25160A *CREATE  Date 18Aug09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG25160A - Apply fix 229655                                */
/*       229655 - Separate RFT Unauthorised report from FTC0230      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
/**/
        DCL   VAR(&TYPE)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
        DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2)
        DCL        VAR(&STRT) TYPE(*DEC) LEN(5 0)
        DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0)
        DCL        VAR(&PMENU) TYPE(*CHAR) LEN(3)
        DCL        VAR(&RNTP) TYPE(*CHAR) LEN(1)
        DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
/**/
        SNDPGMMSG MSG('FT0571 - Unauthorised RFT Payments Report') +
             TOMSGQ(MRUNQ)
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB SWS(00000000)
        CHGVAR     VAR(&RNTP) VALUE(%SST(&PARM 4 1))
        CHGVAR     VAR(&PTYP) VALUE(%SST(&PARM 5 2))
        CHGVAR     VAR(&STRT) VALUE(%SST(&PARM 10 5))
        CHGVAR     VAR(&ENDT) VALUE(%SST(&PARM 15 5))
        CHGVAR     VAR(&PMENU) VALUE(%SST(&PARM 20 3))
/**/
/** Unauthorised Request for Transfer Transactions  **/
/**/
             CALL       PGM(FT0571) PARM(&PTYP &STRT &ENDT +
                          &PMENU &RNTP &RSEQ &RLEV &RENT)
/**/
/**   DATABASE ERROR HANDLING   **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
ENDPGM:
        ENDPGM
