/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Check for EOY processing')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC100 - CHECK FOR END OF YEAR PROCESSING                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 103067  URGENT FIX      DATE  06MAR98       */
/*                      S01408                  DATE  20JUN96       */
/*                      091582                  DATE  27MAR96       */
/*                      S01194                  DATE  16/03/89      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       103067 - Urgent fix.  091582 is not appropriate for R10.6  */
/*                PTF7 and above. Remove fix before Year End.       */
/*       S01408 - Core hook GLC100001 added.                        */
/*       091582 - GL0820 IS NEVER RUN                               */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*/COPY WNCPYSRC,GLC100002                                           */
/************CALL       PGM(GL0820)                          *091582* /*103067*/
/*/COPY WNCPYSRC,GLC100003                                           */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABICD)*/                  /*S01194*/
             CALL       PGM(GL0830)
/*********** DLTOVR     FILE(TABLE)*/                                 /*S01194*/
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXX0XX)) THEN(RETURN)
/**/
                ELSE       CMD(DO)
/**/
                SNDPGMMSG  MSG('YEAR END PROCEDURES WILL NOW BE RUN') +
                TOMSGQ(MOPERQ)
/**/
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*              END OF YEAR UPDATES                                           */
/**/
/***********    OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                /*S01194*/
                CALL GL0810
/**/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
                   CALL       GL0840
/**/
                   ENDDO
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,GLC100001                                           /*S01408*/
/*                                                                   /*S01408*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**/
             SNDPGMMSG  MSG('FILES OUT OF BALANCE') TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
             SNDPGMMSG  MSG('DATABASE IN ERROR') TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
             SNDPGMMSG  MSG('YEAR END PROCEDURES NOW COMPLETE') +
                        TOMSGQ(MOPERQ)
/**/
             RETURN
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
