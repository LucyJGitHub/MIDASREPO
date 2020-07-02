/*********************************************************************/
/*STD    CLPBASE                                                     */
/********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                     */
/*                                                                   */
/*       SECD101   CREATE TRADE EVENTS FOR FORWARD VALUE DATES ON    */
/*                 TRADES - Input Cycle                              */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. DUG503             Date 08Apr18              */
/*       Prev Amend No. DUG405             DATE 30JUL04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             DATE 10DEC90              */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG503 - Events by Value Date Report                        */
/*       DUG405 - Input Cycle Events by Value Date Reporting.        */
/*                Upgrade of S20208/S20039 from ABS 2.3 to R4.01.    */
/*                Based on SEC1101 (from R4) & SEC9101 (from 2.3).   */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01179 - RELEASE                                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2017')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/

/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
/*/COPY WNCPYSRC,SEC1101001                                      */
/* SETUP AND SEND PGM MESSAGE                                    */

             CHGVAR     VAR(&MEM) VALUE('SECD101 - Create +
                        Trade Events')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/* CLEAR SWITCHES                                                */

             CHGJOB SWS(00000000)

/* CLEAR FILES                                                   */

             CLRPFM     FILE(ITREVED)                                 /*DUG405*/
             CLRPFM     FILE(ITREVEA)                                 /*DUG405*/
             CLRPFM     FILE(IPCTEVD)                                 /*DUG405*/
             CLRPFM     FILE(IPCTEVA)                                 /*DUG405*/
/*/COPY WNCPYSRC,SEC1101002                                     */
             OVRDBF     FILE(TREVED) TOFILE(ITREVED)                  /*DUG405*/
             OVRDBF     FILE(TREVEA) TOFILE(ITREVEA)                  /*DUG405*/
             OVRDBF     FILE(PCTEVD) TOFILE(IPCTEVD)                  /*DUG405*/
             OVRDBF     FILE(PCTEVA) TOFILE(IPCTEVA)                  /*DUG405*/
             OVRDBF     FILE(SE1400AU) TOFILE(SED140AU)               /*DUG405*/

/* CALL PROGRAM                                                  */

             CALL       PGM(SE1400)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SECD101  - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */

             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SECD101  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2017')
             ENDPGM
