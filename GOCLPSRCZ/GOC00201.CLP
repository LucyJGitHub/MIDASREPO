/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Pre-processing for Univ. trans upd - COB')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC00201 - Preliminary processing for GOC0020 series        */
/*                  of components                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGP017             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP014  *CREATE    Date 27Feb09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP017 - Global Layer - GOC0100 Task Split                  */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                     */                   /*CGP017*/
             PGM        PARM(&FILNAM)                                                     /*CGP017*/
 
             DCL        VAR(&FILNAM) TYPE(*CHAR) LEN(10)                                  /*CGP017*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC00201 - Preliminary processing for +
                          Universal Transactions Update') TOMSGQ(MRUNQ)
 
             CHGJOB SWS(00000000)
 
/* clear files */
/**********  CLRPFM     FILE(GOTRAPPD) MBR(*ALL)    */                                    /*CGP017*/
/**********  CLRPFM     FILE(GOPOSNPD) MBR(*ALL)    */                                    /*CGP017*/
/**********  CLRPFM     FILE(GOCASHPD) MBR(*ALL)    */                                    /*CGP017*/
 
/**********  CLRPFM     FILE(GOWPOSNPD) MBR(*ALL)   */                                    /*CGP017*/
/**********  CLRPFM     FILE(GOWEVNTPD) MBR(*ALL)   */                                    /*CGP017*/
             CLRPFM     FILE(&FILNAM) MBR(*ALL)                                           /*CGP017*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC00201 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
