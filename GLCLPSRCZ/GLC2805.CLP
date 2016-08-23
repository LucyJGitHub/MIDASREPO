/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis Intra-day Proj. Mvmts. Generation')   */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas-Fontis Interface                             */
/*                                                                  */
/*       GLC2805    Fontis Message Generation                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amendment No. 169526           Date 20Oct99           */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amendment No. CGL004 *CREATE   Date 21JAN97           */
/*                                                                  */
/*********************************************************************/
/*                                                                  */
/*       169526 - Provide recovery for GLFONAPD & GLRSSVPD.         */
/*                Here, set U7 and U8 on for each DBERR  processing */
/*                to prevent GLC2818 from going on any further      */
/*                after any error on GL2805 that does not go through*/
/*                *PSSR.  Also, rollback changes.                   */
/*       CGL004 - Midas-Fontis Interface                            */
/*                                                                  */
/*********************************************************************/
/**/
             PGM        PARM(&ANUM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&MNM) TYPE(*CHAR) LEN(10) +
                           VALUE('FONTIS942 ')
             DCL        VAR(&ANUM) TYPE(*CHAR) LEN(18)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(DBERR))
/**/
             CHGVAR     VAR(&MSG) VALUE('GLC2805 - Fontis Message +
                          Generation')
/* Send message to MRUNQ */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG(&MSG)
 
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
 
             CLRPFM     FILE(GLFDTAPD) MBR(FONTIS942)
             OVRDBF     FILE(GLFDTAPD) MBR(FONTIS942)
             CALL       PGM(GL2805) PARM(&MNM &ANUM)
             DLTOVR     FILE(GLFDTAPD)
/*/COPY WNCPYSRC,GLC2805001                                          */
 
/* If either job user switches 7 or 8 are on, perform standard */
/* database error processing */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
               GOTO       CMDLBL(DBERR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 50))
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                 /*169526*/
             ROLLBACK                                                 /*169526*/
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
