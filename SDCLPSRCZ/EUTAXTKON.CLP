/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EU Saving Tax Take-on')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas   - MM Module                                         */
/*                                                                   */
/*       EUTAXTKON - EU TAX TAKE-ON PROGRAM                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/*       Last Amend No. MD037022           Date 05Feb16              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG16152           Date 20Feb08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      236983             Date 31Aug05              */
/*                      236980             Date 16SEP05              */
/*                      235798             Date 30AUG05              */
/*                      235045             Date 20Jul05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD037022 - Database Error encountered when Switching Off    */
/*                  feature CGL031                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG16152 - CGL031 Initialization pgm error                  */
/*       236983 - Split Cpyf in two separate steps.                  */
/*       236980 - Copy command in error                              */
/*       257980 - Create opening position for Securities Matured     */
/*                between effective date and RUND                    */
/*       235045 - New EU Saving Tax Take-on                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)                                                       /*CSE028*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             CHGJOB     SWS(00000000)
 
             IF         COND(&MODE = '1') THEN(DO)
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
/**/
             OVRDBF     FILE(ETCPOSND) TOFILE(WKETCPOSND) OVRSCOPE(*JOB) SHARE(*NO)
             OVRDBF     FILE(ETCPOSL0) TOFILE(WKETCPOSL0) OVRSCOPE(*JOB) SHARE(*NO)
             OVRDBF     FILE(ETCPOSL3) TOFILE(WKETCPOSL3) OVRSCOPE(*JOB) SHARE(*NO)
             OVRDBF     FILE(ETCPOSL4) TOFILE(WKETCPOSL4) OVRSCOPE(*JOB) SHARE(*NO)
 
             CLRPFM     FILE(WKETCPOSND)
 
             CALL       PGM(SEETCPOPN)
/**          CALL       PGM(SEETCPMATP)                                                  /*257980*/
             CALL       PGM(SEETCPTRD)
/**/
             CLRPFM     FILE(WKETCPTMVD)
             CLRPFM     FILE(WKETCPDMVD)
             CLRPFM     FILE(WKETCSINPD)
             OVRDBF     FILE(SDCSINPD) TOFILE(WKETCSINPD) OVRSCOPE(*JOB) SHARE(*NO)
 
             CALL       PGM(SE006660P)
 
             CALL       PGM(SEPSTLTKNP)
 
             CALL       PGM(DLDEALTKNP)
 
             CALL       PGM(SD006666PP)
             CALL       PGM(SD006667PP)
 
             DLTOVR     FILE(ETCPOSND) LVL(*JOB)
             DLTOVR     FILE(ETCPOSL0) LVL(*JOB)
             DLTOVR     FILE(ETCPOSL3) LVL(*JOB)
             DLTOVR     FILE(ETCPOSL4) LVL(*JOB)
             DLTOVR     FILE(SDCSINPD) LVL(*JOB)
             COMMIT
             ENDDO
 
             IF         COND(&MODE = '2') THEN(DO)
/**          CPYF       FROMFILE(WKETCPOSND) TOFILE(ETCPOSND) +                           /*236980*/
/**                       FROMMBR(*ALL) TOMBR(*FROMMBR) +                                 /*236980*/
/**                       MBROPT(*REPLACE)                                                /*236980*/
/**          CPYF       FROMFILE(WKETCSINPD) TOFILE(SDCSINPD) +                           /*236980*/
/**                       FROMMBR(*ALL) TOMBR(*FROMMBR) +                                 /*236980*/
/**                       MBROPT(*REPLACE)                                                /*236980*/
             CPYF       FROMFILE(WKETCPOSND) TOFILE(ETCPOSND) +
                          FROMMBR(*FIRST) TOMBR(*FIRST) +
                          MBROPT(*REPLACE)                                                /*236980*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG16152*/
             ENDDO                                                                        /*236983*/
                                                                                          /*236983*/
             IF         COND(&MODE = '3') THEN(DO)                                        /*236983*/
             CPYF       FROMFILE(WKETCSINPD) TOFILE(SDCSINPD) +
                          FROMMBR(*FIRST) TOMBR(*FIRST) +
                          MBROPT(*REPLACE)                                                /*236980*/
             MONMSG     MSGID(CPF2909)                                                  /*MD037022*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG16152*/
             ENDDO
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
