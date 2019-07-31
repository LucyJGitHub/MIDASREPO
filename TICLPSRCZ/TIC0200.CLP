/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Trade innovation outgoing msg processing')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - TI Module                                           */
/*                                                                   */
/*       TIC0200 - Trade Innovation Outgoing Message Processing     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 139756             Date 18Feb99              */
/*                      CTI001  *CREATE    Date 14Nov97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       139756 - Commitment control scope incorrect                 */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DS &FILE &LIBRARY)
 
/*/COPY WNCPYSRC,TIC0200INT                                          */
 
             DCL        VAR(&DS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             OVRMSGF    MSGF(TIUSRMSG) TOMSGF(GBTIUSRMSG)
             OVRMSGF    MSGF(MIDAS) TOMSGF(GBMIDAS)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0200MPS                                          */
 
/* Start commitment control */
 
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))         */ /*139756*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139756*/
 
/* Copy TI SWIFT messages to MSTISOPD */
 
             CPYF       FROMFILE(&LIBRARY/&FILE) TOFILE(MSTISOPD) +
                          FROMMBR(*FIRST) TOMBR(*FIRST) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
 
/* Call TI0200 to process messages outgoing to SWIFT from MIDAS */
 
             CALL       PGM(TI0200) PARM(&DS &FILE &LIBRARY)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,TIC0200MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0200ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0200 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,TIC0200END                                          */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
