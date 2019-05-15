/*********************************************************************/
/*********LPBASEBND***************************************************/                 /*BUG24908*/
/*STD    CLPBASE                                                     */                 /*BUG24908*/
/*EXI    TEXT('Midas @24 KWG data extraction Report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0100 - Midas @24 KWG data extraction                     */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. M029184            Date 25Nov14              */
/*                      CER059             Date 19Jul10              */
/*                      BUG26298           Date 06Oct09              */
/*                      262095             Date 14Oct09              */
/*                      BUG24908           Date 13Jul08              */
/*                      CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD029184 - COB ERC0100 ends in error (dumped) but the COB   */
/*                  didn't stop with a failed component.             */
/*                - Amended CL program to make sure the COB will     */
/*                  stop if U7 and U8 job switches are ON.           */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26298 - Enable export to Meridian                        */
/*       262095 - Component is in error but does not halt.           */
/*                Catch error from RPG when switches 7 and 8 are on. */
/*                Change BankName to ServiceProvider.                */
/*       BUG24908 - ERC00100 00001. Decimal data error. Convert the  */
/*                  the program to OPM.                              */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PUTP &PFNR &PRTNCDE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008.')
             DCL        VAR(&PUTP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFNR) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PRTNCDE) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&PBKN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WFNM) TYPE(*CHAR) LEN(10) VALUE('ERCRCDPD')
             DCL        VAR(&WTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CCSID) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PSYSOP01) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL01) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP02) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL02) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP03) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL03) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP04) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL04) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP05) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL05) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP06) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL06) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP07) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL07) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP08) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL08) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP09) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL09) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PSYSOP10) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&PSYSVAL10) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
 
/** Retrieve type of job (Interactive or Batch) */
             RTVJOBA    TYPE(&WTYPE) CCSID(&CCSID)
 
/** Change CCSID of job to ensure proper conversions */
             CHGJOB     CCSID(65535)
 
/** Override C-Record file to version stored in system value */
/**********  CHGVAR     VAR(&PSYSOP01) VALUE('BankName') */                               /*262095*/
             CHGVAR     VAR(&PSYSOP01) VALUE('ServiceProvider')                           /*262095*/
 
             CALL       PGM(AOSVALR0) PARM(&PRTCD &PSYSOP01 +
                          &PSYSVAL01 &PSYSOP02 &PSYSVAL02 +
                          &PSYSOP03  &PSYSVAL03 &PSYSOP04 +
                          &PSYSVAL04 &PSYSOP05 &PSYSVAL05 +
                          &PSYSOP06 &PSYSVAL06 &PSYSOP07 +
                          &PSYSVAL07 &PSYSOP08 &PSYSVAL08 +
                          &PSYSOP09 &PSYSVAL09 &PSYSOP10 +
                          &PSYSVAL10)
 
             IF         COND(&PRTCD = ' ') THEN(DO)
 
             CHGVAR     VAR(&PBKN) VALUE(%SST(&PSYSVAL01 1 1))
             ENDDO
 
             CHGVAR     VAR(%SST(&WFNM 6 1)) VALUE(&PBKN)
             OVRDBF     FILE(ERCRCDPD) TOFILE(&WFNM) OVRSCOPE(*JOB)
             CLRPFM     FILE(&WFNM)
             CLRPFM     FILE(ERCRBTPD)                                                  /*BUG26298*/
 
/** Override files */
             OVRDBF     FILE(ERACEXL2) OVRSCOPE(*JOB) SHARE(*NO)
             OVRDBF     FILE(ERACEPL0) OVRSCOPE(*JOB) SHARE(*NO)
 
/** Call transmission file creation program */
             CALL       PGM(ER000100) PARM(&PBKN &PUTP &PFNR &PRTNCDE)
             IF         COND(&PRTNCDE *NE 0 *AND &WTYPE *EQ '0') THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ABNOR)                                                   /*MD029184*/
             ENDDO                                                                        /*262095*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*262095*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC000100 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)                                                   /*MD029184*/
             ENDDO
 
/** Meridian Updates */                                                                 /*BUG26298*/
             CALL       PGM(MXC0010) PARM('*NONE' 'ERERCRBTPD')                         /*BUG26298*/
             CALL       PGM(MXC0020) PARM('*NONE' ' ' 'ERERCRBTPD')                     /*BUG26298*/
                                                                                        /*BUG26298*/
             GOTO       CMDLBL(ENDPGM)                                                  /*MD029184*/
                                                                                        /*MD029184*/
/***  PROGRAM ENDED ABNORMALLY  ***/                                                    /*MD029184*/
                                                                                        /*MD029184*/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM ERC0100 ENDED ABNORMALLY - SEE +
                          JOBLOG.') TOMSGQ(MRUNQ MOPERQ)                                /*MD029184*/
             MONMSG     MSGID(CPF0000)                                                  /*MD029184*/
             CHGJOB     SWS(XXXXXX11)                                                   /*MD029184*/
             MONMSG     MSGID(CPF0000)                                                  /*MD029184*/
                                                                                        /*MD029184*/
             DMPCLPGM                                                                   /*MD029184*/
                                                                                        /*MD029184*/
/***  END PROGRAM  ***/                                                                 /*MD029184*/
                                                                                        /*MD029184*/
 ENDPGM:                                                                                /*MD029184*/
                                                                                        /*MD029184*/
/** Delete override */
             DLTOVR     FILE(ERCRCDPD) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ERACEXL2) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ERACEPL0) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
 
/** Reset CCSID of job to previous value */
             CHGJOB     CCSID(&CCSID)
 
             ENDPGM
