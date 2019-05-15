/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loan Increases & Repayments Ccy. Cnvrsn.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC0455 - Loan Increases and Repayments Currency Conversion */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  Close of Business                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR750558           Date 27Apr11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CLE014  *CREATE    Date 20Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR750558 - Do not delete XLOAMSDK and XLOAMSZ1 as they are  */
/*                  being used on other components (Child: AR750559) */
/*       CLE014 - Customer Driven Lending Enhancements               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&CNAM &CSEQ)
 
/** Declare Variables **/
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Set off Switches **/
 
             CHGJOB     SWS(XXXXXX00)
 
/** Check status of the component **/
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
/** Setup library name **/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
 
/** If this is not a restart then create security backup copies **/
 
             IF         COND(&BUSY *EQ 'N') THEN(DO)
/**********    DLTF       FILE(&DPLIB/XLOAMDK)                                          /*AR750558*/
/**********    MONMSG     MSGID(CPF0000)                                                /*AR750558*/
/**********    CPYF       FROMFILE(&DMLIB/LOAMSDK) +                                    /*AR750558*/
/**********                 TOFILE(&DPLIB/XLOAMSDK) +                                   /*AR750558*/
/**********                 MBROPT(*REPLACE) CRTFILE(*YES)*/                            /*AR750558*/
               CPYF       FROMFILE(&DMLIB/LOAMSDK) +
                            TOFILE(&DPLIB/XLOAMSDK) +
                            MBROPT(*REPLACE)                                            /*AR750558*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/**********    DLTF       FILE(&DPLIB/XLOAMSZ1)                                         /*AR750558*/
/**********    MONMSG     MSGID(CPF0000)                                                /*AR750558*/
/**********    CPYF       FROMFILE(&DMLIB/LOAMSZ1) +                                    /*AR750558*/
/**********                 TOFILE(&DPLIB/XLOAMSZ1) MBROPT(*REPLACE) +                  /*AR750558*/
/**********                 CRTFILE(*YES)                                               /*AR750558*/
               CPYF       FROMFILE(&DMLIB/LOAMSZ1) +
                            TOFILE(&DPLIB/XLOAMSZ1) MBROPT(*REPLACE)                    /*AR750558*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/** Update component status to 'Y' **/
 
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')
             ENDDO
 
             ELSE       CMD(DO)
 
/** If this is a restart then copy security copies back to master **/
/** file **/
 
               CPYF       FROMFILE(&DPLIB/XLOAMSDK) +
                            TOFILE(&DMLIB/LOAMSDK) MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(&DMLIB/LOAMSDK))
 
               CPYF       FROMFILE(&DPLIB/XLOAMSZ1) +
                            TOFILE(&DMLIB/LOAMSZ1) MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(&DMLIB/LOAMSZ1))
             ENDDO
 
/** Call loan increases and repayments currency conversion program **/
 
             CALL       PGM(LE0455)
 
/** If call to program is successful, update component status to **/
/** 'N' **/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
/**********    DLTF       FILE(&DPLIB/XLOAMSDK)                                         /*AR750558*/
/**********    MONMSG     MSGID(CPF0000)                                                /*AR750558*/
/**********    DLTF       FILE(&DPLIB/XLOAMSZ1)                                         /*AR750558*/
/**********    MONMSG     MSGID(CPF0000)                                                /*AR750558*/
             ENDDO
 
             ELSE       CMD(DO)
 
/** Perform database error processing **/
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
