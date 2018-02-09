/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER Maturing Collateral Report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0932 - ER Maturing Collateral Report                     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX004             Date 22Jan97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                      Finastra International Limited 2005')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/*  Set off Switches:                                                */
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(ERGUEXPD) SHARE(*YES)
 
             OPNQRYF    FILE((ERGUEXPD)) FORMAT(ERGUEXPD) +
                          QRYSLT('RTSBYI *EQ "D" *or RTSBYI *EQ "C" *OR +
                          RTSBYI *EQ "N"') KEYFLD((RTCOMP) (RTBRCA) +
                          (RTACOF) (RTSBYI) (RTSBYR))
 
             CALL  PGM(ER0932) PARM(&RSEQ &RLEV &RENT)
 
/* If U7 U8 on*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                    RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                    CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 
             DLTOVR     FILE(ERGUEXPD)
             CLOF       OPNID(ERGUEXPD)
 
             GOTO       CMDLBL(ENDPGM)
 
/***  Send Message to User alerting failure.  ***/
 
 ABNOR:      SNDPGMMSG  MSG('ERC0932 - ER Maturity Collateral Report') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) +
                     VALUE('(c) Finastra International Limited +
                            2005')
             ENDPGM
