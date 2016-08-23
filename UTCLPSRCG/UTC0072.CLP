/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Copy one data area to another')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       CPYDTAARA - Copy one data area to another                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP002             Date 12Jul99              */
/*       Prev Amend No. CUP001 *CREATE     Date 11Sep98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP002 - Additional attempts to copy for decimal data areas */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUAL1 &QUAL2)
 
             DCL        VAR(&QUAL1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QUAL2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAARA1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAARA2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDATA) TYPE(*CHAR) LEN(2000)
/************DCL        VAR(&DDATA) TYPE(*DEC) LEN(15 9)                               */ /*CUP002*/
             DCL        VAR(&DDATA9) TYPE(*DEC) LEN(15 9)                                 /*CUP002*/
             DCL        VAR(&DDATA8) TYPE(*DEC) LEN(15 8)                                 /*CUP002*/
             DCL        VAR(&DDATA7) TYPE(*DEC) LEN(15 7)                                 /*CUP002*/
             DCL        VAR(&DDATA6) TYPE(*DEC) LEN(15 6)                                 /*CUP002*/
             DCL        VAR(&DDATA5) TYPE(*DEC) LEN(15 5)                                 /*CUP002*/
             DCL        VAR(&DDATA4) TYPE(*DEC) LEN(15 4)                                 /*CUP002*/
             DCL        VAR(&DDATA3) TYPE(*DEC) LEN(15 3)                                 /*CUP002*/
             DCL        VAR(&DDATA2) TYPE(*DEC) LEN(15 2)                                 /*CUP002*/
             DCL        VAR(&DDATA1) TYPE(*DEC) LEN(15 1)                                 /*CUP002*/
             DCL        VAR(&DDATA0) TYPE(*DEC) LEN(15 0)                                 /*CUP002*/
             DCL        VAR(&LDATA) TYPE(*LGL) LEN(1)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERROR))
 
             CHGVAR     VAR(&DTAARA1) VALUE(%SST(&QUAL1 1 10))
             CHGVAR     VAR(&LIB1) VALUE(%SST(&QUAL1 11 10))
             CHGVAR     VAR(&DTAARA2) VALUE(%SST(&QUAL2 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&QUAL2 11 10))
 
/* Try to copy as *CHAR data area */
             RTVDTAARA  DTAARA(&LIB1/&DTAARA1) RTNVAR(&CDATA)
             MONMSG     MSGID(CPF0812) EXEC(DO)
 
/* Then try to copy as *DEC data area */
/***************RTVDTAARA  DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA)                       */ /*CUP002*/
                RTVDTAARA  DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA9)                         /*CUP002*/
                MONMSG     MSGID(CPF0812) EXEC(DO)
 
/* Then try to copy as *LGL data area */
                   RTVDTAARA  DTAARA(&LIB1/&DTAARA1) RTNVAR(&LDATA)
                   CHGDTAARA  DTAARA(&LIB2/&DTAARA2) VALUE(&LDATA)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
                MONMSG     MSGID(CPF0811) EXEC(DO)                                        /*CUP002*/
                   RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA8)                       /*CUP002*/
                   MONMSG MSGID(CPF0811) EXEC(DO)                                         /*CUP002*/
                      RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA7)                    /*CUP002*/
                      MONMSG MSGID(CPF0811) EXEC(DO)                                      /*CUP002*/
                         RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA6)                 /*CUP002*/
                         MONMSG MSGID(CPF0811) EXEC(DO)                                   /*CUP002*/
                            RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA5)              /*CUP002*/
                            MONMSG MSGID(CPF0811) EXEC(DO)                                /*CUP002*/
                               RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA4)           /*CUP002*/
                               MONMSG MSGID(CPF0811) EXEC(DO)                             /*CUP002*/
                                  RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA3)        /*CUP002*/
                                  MONMSG MSGID(CPF0811) EXEC(DO)                          /*CUP002*/
                                     RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA2)     /*CUP002*/
                                     MONMSG MSGID(CPF0811) EXEC(DO)                       /*CUP002*/
                                        RTVDTAARA DTAARA(&LIB1/&DTAARA1) RTNVAR(&DDATA1)  /*CUP002*/
                                        MONMSG MSGID(CPF0811) EXEC(DO)                    /*CUP002*/
                                           RTVDTAARA DTAARA(&LIB1/&DTAARA1) +
                                                     RTNVAR(&DDATA0)                      /*CUP002*/
                                           CHGDTAARA DTAARA(&LIB2/&DTAARA2) +
                                                     VALUE(&DDATA0)                       /*CUP002*/
                                           GOTO CMDLBL(ENDPGM)                            /*CUP002*/
                                        ENDDO                                             /*CUP002*/
                                        CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA1)   /*CUP002*/
                                        GOTO CMDLBL(ENDPGM)                               /*CUP002*/
                                     ENDDO                                                /*CUP002*/
                                     CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA2)      /*CUP002*/
                                     GOTO CMDLBL(ENDPGM)                                  /*CUP002*/
                                  ENDDO                                                   /*CUP002*/
                                  CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA3)         /*CUP002*/
                                  GOTO CMDLBL(ENDPGM)                                     /*CUP002*/
                               ENDDO                                                      /*CUP002*/
                               CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA4)            /*CUP002*/
                               GOTO CMDLBL(ENDPGM)                                        /*CUP002*/
                            ENDDO                                                         /*CUP002*/
                            CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA5)               /*CUP002*/
                            GOTO CMDLBL(ENDPGM)                                           /*CUP002*/
                         ENDDO                                                            /*CUP002*/
                         CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA6)                  /*CUP002*/
                         GOTO CMDLBL(ENDPGM)                                              /*CUP002*/
                      ENDDO                                                               /*CUP002*/
                      CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA7)                     /*CUP002*/
                      GOTO CMDLBL(ENDPGM)                                                 /*CUP002*/
                   ENDDO                                                                  /*CUP002*/
                   CHGDTAARA DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA8)                        /*CUP002*/
                   GOTO CMDLBL(ENDPGM)                                                    /*CUP002*/
                ENDDO                                                                     /*CUP002*/
 
/************   CHGDTAARA  DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA)                        */ /*CUP002*/
                CHGDTAARA  DTAARA(&LIB2/&DTAARA2) VALUE(&DDATA9)                          /*CUP002*/
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             CHGDTAARA  DTAARA(&LIB2/&DTAARA2) VALUE(&CDATA)
 
             GOTO       CMDLBL(ENDPGM)
ERROR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
 
                  SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm UTC0072') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
ABNOR2:
 /* Receive diagnostic error message */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       CMDLBL(ABNOR2)
             ENDDO
 /* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
