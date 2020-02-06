/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LIMITS REPORTING')                           */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMC0801 - LIMITS REPORTING                                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117             Date 30/10/89             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                  */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)               /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)             /*S01117*/
/*           DCLF       EM0500FM                                  */ /*S01117*/
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('Limits Reporting')
/**/
/*/COPY WNCPYSRC,EMC0801001                                          */
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*           CHGVAR &IN93 '0'                                     */ /*S01117*/
/*           CHGVAR &IN94 '0'                                     */ /*S01117*/
/*           CHGVAR &IN95 '1'                                     */ /*S01117*/
/**/
/**/
/*       A:  SNDRCVF RCDFMT(EM0500FM)                             */ /*S01117*/
/**/
/*           CHGVAR &IN93 '0'                                     */ /*S01117*/
/*           CHGVAR &IN94 '0'                                     */ /*S01117*/
/*           CHGVAR &IN95 '1'                                     */ /*S01117*/
/**/
/*           IF &IN07 RETURN                                      */ /*S01117*/
/*           ELSE DO                                              */ /*S01117*/
/*               IF (&U1 *EQ Y) THEN(DO)                          */ /*S01117*/
/*                   CHGJOB SWS(1XXXXXXX)                         */ /*S01117*/
/*               ENDDO                                            */ /*S01117*/
/**/
/*               ELSE IF (&U1 *NE ' ') THEN(DO)                   */ /*S01117*/
/*                  CHGVAR &IN95 '0'                              */ /*S01117*/
/*                  CHGVAR &IN93 '1'                              */ /*S01117*/
/*               ENDDO                                            */ /*S01117*/
/**/
/*               IF (&U2 *EQ Y) THEN(DO)                          */ /*S01117*/
/*                   CHGJOB SWS(X1XXXXXX)                         */ /*S01117*/
/*               ENDDO                                            */ /*S01117*/
/**/
/*               ELSE IF (&U2 *NE ' ') THEN(DO)                   */ /*S01117*/
/*                  CHGVAR &IN95 '0'                              */ /*S01117*/
/*                  CHGVAR &IN94 '1'                              */ /*S01117*/
/*               ENDDO                                            */ /*S01117*/
/**/
/*           ENDDO                                                */ /*S01117*/
/*           IF (&IN95 *EQ '0') GOTO A                            */ /*S01117*/
/**/
             IF         COND(%SST(&RPARM 1 1) *EQ 'Y') THEN(CHGJOB +
                          SWS(1XXXXXXX))                             /*S01117*/
             IF         COND(%SST(&RPARM 2 1) *EQ 'Y') THEN(CHGJOB +
                          SWS(X1XXXXXX))                             /*S01117*/
/*/COPY WNCPYSRC,EMC0801002                                          */
/*           CALL       PGM(EM0500)                               */ /*S01117*/
             CALL       PGM(EM0500) PARM(&RSEQ &RENT)                /*S01117*/
/**/
/*/COPY WNCPYSRC,EMC0801003                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
           ENDPGM
