/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('GL Balances in Cons. Euro Cy by Branch - GL Level')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Genearl Ledger Module                               */
/*                                                                   */
/*       CLP/GLC76E - GL Balances in Consolidated Euro Ccy by Branch */
/*                    on GL account                                  */
/*                                                                   */
/*       Function: To consolidate and group all 'In' currencies      */
/*                 together for the report program PGM/GL0750.       */
/*                                                                   */
/*       Called By: GLC0750 - GL Balances in one Ccy; GL A/C level   */
/*                                                                   */
/*       Calls  :   GL0746 - GL Balances Sort for EMU - 2            */
/*                  GL0750 - GL Balances Report by account code      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU011  *CREATE    Date 11Mar98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU011 - EMU Position/Risk Reporting                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTYP &RSEQ &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,GLC76E001                                           */
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
/** Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                AUT(*EXCLUDE)
             ENDDO
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB   SWS(01001X00)
 
             SNDPGMMSG  MSG('GLC76E- GL Balances in Cons. Euro Ccy +
                          by Branch at GL A/C  Level') TOMSGQ(MRUNQ)
 
             CLRPFM     FILE(GLX16)
 
/** Extract records to the PF/GLEXTRPD */
 
             OVRDBF     FILE(GLEXTRPD) SHARE(*NO)
             MONMSG     MSGID(CPF0000)
             OPNQRYF    FILE((GLEXGC) (SDCURRPD)) FORMAT(GLEXTRPD) +
                          KEYFLD((*MAPFLD/ECSS *ASCEND) (GLEXGC/CCY)) +
                          JFLD((GLEXGC/CCY SDCURRPD/A6CYCD)) +
                          MAPFLD((ECSS A6SSNB) (INCY A6INCY))
             CPYFRMQRYF FROMOPNID(GLEXGC) TOFILE(GLEXTRPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2909)
             CLOF       OPNID(GLEXGC)
             DLTOVR     FILE(GLEXTRPD)
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(GL0746) PARM(&RENT)
 
             OVRDBF     FILE(SGLEX) TOFILE(GLX16)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,GLC76E002                                           */
             CALL       PGM(GL0750) PARM(&RTYP &RSEQ &RENT)
/*/COPY WNCPYSRC,GLC76E003                                           */
 
             DLTOVR     FILE(SGLEX)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('File Out Of Balance - SGLEX') +
                          TOMSGQ(MOPERQ MRUNQ))
 
             GOTO       CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('GLC76E Ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
