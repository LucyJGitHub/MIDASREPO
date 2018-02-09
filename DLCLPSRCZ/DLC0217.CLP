/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Adjustments to Accrued Interest -I/C')       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0217  - LIST OF ADJUSTMENTS TO ACCRUED INTEREST TODAY   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E47380             Date 1FEb93               */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       E47380 - CREATED SO AVAILABLE ON REQUEST IN INPUT CYCLE    */
/********************************************************************/
             PGM PARM(&TYPE &RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)*/
   DCL VAR(&TYPE) TYPE(*CHAR) LEN(2) /* MM, FX, or ALL '  '*/
   CHGVAR  VAR(&RENT) VALUE(ALL)
             CALL       PGM(DL0220) PARM(&RSEQ &RENT)
/*   ERROR MESSAGES                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
