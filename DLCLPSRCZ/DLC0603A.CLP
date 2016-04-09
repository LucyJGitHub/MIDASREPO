/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL COB S.W.I.F.T. confirmations')               */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*        DLC0603A   C.O.B. S.W.I.F.T. Confirmations                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. LN0299            DATE  30MAY90             */
/*       PREV AMEND NO. S17216            DATE  25APR90             */
/*                      E243              DATE  26FEB89             */
/*            AMEND NO. S01117            DATE  17/07/89            */
/*            AMEND NO. S01179            DATE  10/09/88            */
/*                                                                  */
/********************************************************************/
/*       LN0299 - S17216 NOT NEEDED                                 */
/*       S17216 - RE DESIGN TO STOP LOCK OUT OF MSIXOPF,MSMSOPF     */
/*       E243   - REMOVE EXCESS PARAMETERS                          */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01179 - AS400 CONVERSION                                  */
/********************************************************************/
/*********** PGM                                                      /*S01117*/
/*********** PGM  PARM(&RSEQ)                                *S01117* /*E243*/
             PGM                                                      /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**DCL*VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number /*S01117* /*E243*/
/**DCL*VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/*S01117*/ /*E243*/
/**DCL*VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/*S01117* /*E243*/
/**********  DCLDTAARA  DTAARA(MSSTAT)                                  S01179*/
/**********  DCLDTAARA  DTAARA(MSFCTL)                                  S01179*/
/**********  DCLDTAARA  DTAARA(MSFCTLBK)                                S01179*/
/**********  DCLDTAARA  DTAARA(LDA)                                     S01179*/
/**/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/************DCL        VAR(&MSFCTL) TYPE(*CHAR) LEN(256)  /*S01179*/ /*S17216*/
/************DCL        VAR(&MSFCTLBK) TYPE(*CHAR) LEN(256)/*S01179*/ /*S17216*/
             DCL        VAR(&MSFCTL) TYPE(*CHAR) LEN(256)             /*LN0299*/
             DCL        VAR(&MSFCTLBK) TYPE(*CHAR) LEN(256)           /*LN0299*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(00000000)
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/*RY:        ALCOBJ     OBJ((MSIXOPF *FILE *EXCL)) WAIT(30)           /*S17216*/
/*********** MONMSG     MSGID(CPF1619) EXEC(GOTO CMDLBL(TRY           /*S17216*/
/*********** CLRPFM     FILE(MSMSOBK)                                 /*S17216*/
/*********** CLRPFM     FILE(MSIXOBK)                                 /*S17216*/
/*********** CPYF       FROMFILE(MSMSOPF) TOFILE(MSMSOBK) MBROPT(*A*/ /*S17216*/
/*********** CPYF       FROMFILE(MSIXOPF) TOFILE(MSIXOBK) MBROPT(*A*/ /*S17216*/
/*********** ALCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                */ /*S17216*/
/*********** ALCOBJ     OBJ((MSFCTLBK *DTAARA *EXCL))              */ /*S17216*/
 TRY:        ALCOBJ     OBJ((MSIXOPF *FILE *EXCL)) WAIT(30)           /*LN0299*/
             MONMSG     MSGID(CPF1619) EXEC(GOTO CMDLBL(TRY))         /*LN0299*/
             CLRPFM     FILE(MSMSOBK)                                 /*LN0299*/
             CLRPFM     FILE(MSIXOBK)                                 /*LN0299*/
             CPYF      FROMFILE(MSMSOPF) TOFILE(MSMSOBK) MBROPT(*ADD) /*LN0299*/
             CPYF      FROMFILE(MSIXOPF) TOFILE(MSIXOBK) MBROPT(*ADD) /*LN0299*/
             ALCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                   /*LN0299*/
             ALCOBJ     OBJ((MSFCTLBK *DTAARA *EXCL))                 /*LN0299*/
/*********** RCVDTAARA  DTAARA(MSFCTL)                                  S01179*/
/*********** RTVDTAARA  DTAARA(MSFCTL) RTNVAR(&MSFCTL)     /*S01179*/ /*S17216*/
/*********** CHGDTAARA  DTAARA(MSFCTLBK) VALUE(&MSFCTL)            */ /*S17216*/
/*********** DLCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                */ /*S17216*/
             RTVDTAARA  DTAARA(MSFCTL) RTNVAR(&MSFCTL)                /*LN0299*/
             CHGDTAARA  DTAARA(MSFCTLBK) VALUE(&MSFCTL)               /*LN0299*/
             DLCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                   /*LN0299*/
             SNDPGMMSG  MSG('S.W.I.F.T. End of Day Confirmations') +
                          TOMSGQ(MRUNQ)
/**/
/*********** ALCOBJ     OBJ((MSSTAT *DTAARA *EXCL))                */ /*S17216*/
             ALCOBJ     OBJ((MSSTAT *DTAARA *EXCL))                   /*LN0299*/
/**/
/**********  RCVDTAARA  DTAARA(MSSTAT)                                  S01179*/
/*********** RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&MSSTAT)     /*S01179*/ /*S17216*/
             RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&MSSTAT)                /*LN0299*/
/**/
/*  CLEAR DLFCTL                                        */ /*S17216*/ /*LN0299*/
/************CALL       MS0504D                         */ /*S17216*/ /*LN0299*/
/************CLRPFM     FILE(MSMSODL)                   */ /*S17216*/ /*LN0299*/
/************CLRPFM     FILE(MSIXODL)                   */ /*S17216*/ /*LN0299*/
/************OVRDBF     FILE(MSIXO)   TOFILE(MSIXDLO)   */ /*S17216*/ /*LN0299*/
/************OVRDBF     FILE(MSMSOPF) TOFILE(MSMSODL)   */ /*S17216*/ /*LN0299*/
/*********** CALL       PGM(DL1805)                                   /*S01117*/
/*********** CALL       PGM(DL1805) PARM(&RSEQ)              *S01117* /*E243*/
             CALL       PGM(DL1805)                                   /*S01117*/
/************DLTOVR     FILE(MSIXO)                     */ /*S17216*/ /*LN0299*/
/************DLTOVR     FILE(MSMSOPF)                   */ /*S17216*/ /*LN0299*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*S17216*/
/***********      CLRPFM FILE(MSMSOPF)                             */ /*S17216*/
/***********      CLRPFM FILE(MSIXOPF)                             */ /*S17216*/
/***********      CPYF   FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(**/ /*S17216*/
/***********      CPYF   FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(**/ /*S17216*/
/***********      ALCOBJ     OBJ((MSFCTL *DTAARA *EXCL))           */ /*S17216*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*LN0299*/
                  CLRPFM FILE(MSMSOPF)                                /*LN0299*/
                  CLRPFM FILE(MSIXOPF)                                /*LN0299*/
                  CPYF FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(*ADD) /*LN0299*/
                  CPYF FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(*ADD) /*LN0299*/
                  ALCOBJ     OBJ((MSFCTL *DTAARA *EXCL))              /*LN0299*/
/*********        RCVDTAARA  DTAARA(MSFCTLBK)                           S01179*/
/***********      RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)/*S01179*S17216*/
/***********      CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)       */ /*S17216*/
/***********      DLCOBJ     OBJ((MSIXOPF *FILE *EXCL))            */ /*S17216*/
/***********      GOTO ABNOR                                       */ /*S17216*/
/*********** ENDDO                                                 */ /*S17216*/
                  RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)       /*LN0299*/
                  CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)          /*LN0299*/
                  DLCOBJ     OBJ((MSIXOPF *FILE *EXCL))               /*LN0299*/
                  GOTO ABNOR                                          /*LN0299*/
             ENDDO                                                    /*LN0299*/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                  SNDPGMMSG    MSG('FILE CONTROLS OUT OF BALANCE') +
                          TOMSGQ(MRUNQ MOPERQ)
/***********      CLRPFM  FILE(MSMSOPF)                            */ /*S17216*/
/***********      CLRPFM  FILE(MSIXOPF)                            */ /*S17216*/
/***********      CPYF   FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(**/ /*S17216*/
/***********      CPYF   FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(**/ /*S17216*/
                  CLRPFM  FILE(MSMSOPF)                               /*LN0299*/
                  CLRPFM  FILE(MSIXOPF)                               /*LN0299*/
                  CPYF FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(*ADD) /*LN0299*/
                  CPYF FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(*ADD) /*LN0299*/
/*********        RCVDTAARA  DTAARA(MSFCTLBK)                           S01179*/
/***********      RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)/*S01179*S17216*/
/***********      CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)       */ /*S17216*/
/***********    GOTO      CMDLBL(ABNOR)                 S17216*/      /*LN0299*/
                  RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)       /*LN0299*/
                  CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)          /*LN0299*/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
/**********     RCVDTAARA  DTAARA(LDA)                                  S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/**********     CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))   /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))   /*S01117*/
/**/
/**********     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  /*S01117*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/***********    CLRPFM  FILE(MSMSOPF)                              */ /*S17216*/
/***********    CLRPFM  FILE(MSIXOPF)                              */ /*S17216*/
/***********    CPYF    FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(*A*/ /*S17216*/
/***********    CPYF    FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(*A*/ /*S17216*/
                CLRPFM  FILE(MSMSOPF)                                 /*LN0299*/
                CLRPFM  FILE(MSIXOPF)                                 /*LN0299*/
                CPYF  FROMFILE(MSMSOBK) TOFILE(MSMSOPF) MBROPT(*ADD)  /*LN0299*/
                CPYF  FROMFILE(MSIXOBK) TOFILE(MSIXOPF) MBROPT(*ADD)  /*LN0299*/
/*********      RCVDTAARA  DTAARA(MSFCTLBK)                             S01179*/
/***********    RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)/*S01179* *S17216*/
/***********    CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)         */ /*S17216*/
/***********    GOTO      CMDLBL(ABNOR)                      S17216*/ /*LN0299*/
                RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&MSFCTLBK)         /*LN0299*/
                CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTLBK)            /*LN0299*/
             ENDDO
/**********  CALL       PGM(MSC5050) PARM('DL')              S17216*/ /*LN0299*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                     S17216*/ /*LN0299*/
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Outgoing S.W.I.F.T. Messages Generation +
                          Program ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* END:        DLCOBJ     OBJ((MSSTAT *DTAARA *EXCL))              */ /*S17216*/
/*********** DLCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                */ /*S17216*/
/*********** MONMSG     MSGID(CPF1005)                             */ /*S17216*/
/*********** DLCOBJ     OBJ((MSFCTLBK *DTAARA *EXCL))              */ /*S17216*/
/*********** DLCOBJ     OBJ((MSIXOPF *FILE *EXCL))                 */ /*S17216*/
 END:        DLCOBJ     OBJ((MSSTAT *DTAARA *EXCL))                   /*LN0299*/
             DLCOBJ     OBJ((MSFCTL *DTAARA *EXCL))                   /*LN0299*/
             MONMSG     MSGID(CPF1005)                                /*LN0299*/
             DLCOBJ     OBJ((MSFCTLBK *DTAARA *EXCL))                 /*LN0299*/
             DLCOBJ     OBJ((MSIXOPF *FILE *EXCL))                    /*LN0299*/
/* END:                                                   S17216*/    /*LN0299*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
