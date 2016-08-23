/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Journal individual file from Jrn Maint Sc')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0310 - Journal individual file from Journal              */
/*                 Maintenance Screen                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 100763 *CREATE     Date 13MAR96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       100763 - Enable individual journalling on PF                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &FILE &TOJRN)
 
/*/COPY WNCPYSRC,SCC0310INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOJRN) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,SCC0310001                                          */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0310MPS                                          */
 
             IF         COND(&MODE *EQ 'J') THEN(DO)
/*/COPY WNCPYSRC,SCC0310002                                          */
                STRJRNPF   FILE(&FILE) JRN(&TOJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                    RTVMSG     MSGID(SCM0111) MSGF(GBMIDASMSG) +
                                MSGDTA(&FILE) MSG(&MESSAGE)
                    CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                                VALUE(&MESSAGE)
                   CALL       PGM(SCC0010) PARM(SCC0310 JOBLOG Y)
                ENDDO
/*/COPY WNCPYSRC,SCC0310003                                          */
             ENDDO
 
             IF         COND(&MODE *EQ 'N') THEN(DO)
/*/COPY WNCPYSRC,SCC0310004                                          */
                ENDJRNPF   FILE(&FILE)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   RTVMSG     MSGID(SCM0112) MSGF(GBMIDASMSG) +
                               MSGDTA(&FILE) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                               VALUE(&MESSAGE)
                   CALL       PGM(SCC0010) PARM(SCC0310 JOBLOG Y)
                ENDDO
/*/COPY WNCPYSRC,SCC0310005                                          */
             ENDDO
 
/*/COPY WNCPYSRC,SCC0310MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0310ERR                                          */
 
             RTVMSG     MSGID(SCM0112) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(SCC0010) PARM(SCC0310 JOBLOG Y)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0310END                                          */
 
             ENDPGM
