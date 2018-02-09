/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas DL List Today Deal - Fix Deposit & Non-Fixed')  */
/********************************************************************/
/*                                                                  */
/*       Midas    - Dealing Module                                  */
/*                                                                  */
/*       DLC0601G - List of Today's Deals                           */
/*                  Fixed Deposits and Non-Fixed Deposits           */
/*                                                                  */
/*       (c) Finastra International Limited 2004                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL016  *CREATE    Date 06Oct04              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL016 - Automatic Rollover of Fixed Term Loans/Deposits   */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&TYPE &STYP &RSEQ &RLVL &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STYP) TYPE(*CHAR) LEN(2)
 
/** List of Todays Deals - Fixed Deposits and Non-Fixed Deposits */
 
             IF         COND((&TYPE *NE 'FX') *AND (&TYPE *NE 'MM')) +
                          THEN(DO)
             SNDPGMMSG  MSG('List of Todays Deals - Fixed Deposits +
                          and Non-Fixed Deposits') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
             ENDDO
 
/** List of Todays FX Deals */
 
             IF         COND(&TYPE *EQ 'FX') THEN(DO)
             SNDPGMMSG  MSG('LIST OF TODAYS FX DEALS') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
             ENDDO
 
/** List of Todays MM Deals */
 
             IF         COND(&TYPE *EQ 'MM') THEN(DO)
                        SNDPGMMSG  MSG('LIST OF TODAYS MM DEALS') +
                                   TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             ENDDO
 
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
 
/** Position File if for a specific Branch */
 
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)
             OVRDBF     FILE(DTRSD) POSITION(*KEY 3 DTRIXDF ('DD' +
                          *CAT &RENT))
             OPNDBF     FILE(DTRSD) OPTION(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLTOVR     FILE(DTRSD)
             ENDDO
             ENDDO
 
             CALL       PGM(DL0207) PARM(&TYPE &STYP &RSEQ &RENT)
 
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE '   +
                          ')) THEN(DO)
             DLTOVR     FILE(DTRSD)
             CLOF       OPNID(DTRSD)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/** ERROR MESSAGES */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
END:         ENDPGM
