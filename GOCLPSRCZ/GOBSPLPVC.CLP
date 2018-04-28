/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO BSPL Prompt Validity Checker')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOBSPLPVC - BSPL Prompt Validity Checker                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM( &RQTYP &RQID &RRQID +
                              &ZNGL +
                              &BRC &BRGRP &BRCON +
                              &RPSET &HDPTH &CHART +
                              &RELPN &CYR &CMTH    +
                              &RPTYP &RMDUR +
                              &INTDTS +
                              &REPDTS +
                              &ACDBD &PRTZB &ROUND +
                              &IFCTFR &IBCTFR      +
                              &INSID &DESC &EXPRT  +
                              &SUBMIT              +
                              &NEXTSEQ )
 
             DCL        VAR(&RQTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RQID)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&RRQID) TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&ZNGL) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&BRC)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&BRGRP)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&BRCON)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RPSET)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&HDPTH)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&CHART)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RELPN)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CYR)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&CMTH)    TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&RPTYP)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMDUR)  TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&INTDTS)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&REPDTS)    TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&ACDBD)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTZB)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ROUND)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&IFCTFR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IBCTFR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&INSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DESC)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&EXPRT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&SUBMIT)  TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&NEXTSEQ) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&RFREQ)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RDAYN)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&RDATE)  TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&FLDNA)  TYPE(*CHAR) LEN(750)
             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(525)
             DCL        VAR(&MSGDT)  TYPE(*CHAR) LEN(3375)
             DCL        VAR(&IX)     TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&SCNFMT)  TYPE(*CHAR) LEN(186)
             DCL        VAR(&FILFMT)  TYPE(*CHAR) LEN(185)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&CNT)    TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
 
/* GET THE ZONE RUNNING THE REPORT */
 
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD *= '       ') THEN(DO)                        */ /*BUG18886 */
                IF         COND(&RTCD *NE '       ') THEN(DO)                          /*BUG18886 */
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 
/* PROMPT VALIDATION*/
 
             CALL PGM(GOBSPLPVL)   PARM(&RTCD &ERMS            +
                                        &RQTYP &RQID           +
                                        &ZNGL &ZOZONE          +
                                        &BRC &BRGRP &BRCON     +
                                        &RPSET &HDPTH &CHART   +
                                        &RELPN &CYR &CMTH      +
                                        &RPTYP &RMDUR  +
                                        &INTDTS        +
                                        &REPDTS        +
                                        &ACDBD &PRTZB &ROUND +
                                        &IFCTFR &IBCTFR      +
                                        &INSID               +
                                        &DESC                +
                                        &EXPRT               +
                                        &RFREQ &RDAYN &RDATE +
                                        &SCNFMT              +
                                        &FLDNA  &MSGID &MSGDT +
                                        &IX                   +
                                        &FILFMT               +
                                                           )
             RCLACTGRP  ACTGRP(GOBSPLPVL)
 
/**********  IF         COND(&IX *= 0) THEN(DO)                                     */ /*BUG18886 */
             IF         COND(&IX *NE 0) THEN(DO)                                       /*BUG18886 */
 
             CHGVAR     VAR(&CNT) VALUE(1)
 
/**********  IF         COND(%SST(&MSGID &CNT 7) *= '       ') THEN(DO)             */ /*BUG18886 */
DOLOOP:      IF         COND(%SST(&MSGID &CNT 7) *NE '       ') THEN(DO)               /*BUG18886 */
             SNDPGMMSG  MSGID(%SST(&MSGID &CNT 7)) MSGF(GBMIDAS) +
                          MSGTYPE(*DIAG)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             CHGVAR     VAR(&CNT) VALUE(&CNT + 7)
             IF         COND(&CNT *LT 70) THEN(GOTO CMDLBL(DOLOOP))
 
             SNDPGMMSG    MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
