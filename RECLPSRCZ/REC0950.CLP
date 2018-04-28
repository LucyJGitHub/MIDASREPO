/*STD    CLPBASE                                                     */
/*EXI    TEXT('RE Retail Interest Summary Extract')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0950 - Retail Interest Summary Extract                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CCB023             Date 06Aug12              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG23578 *CREATE   Date 24Mar09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23578 - To generate Retail Interest Summary              */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             SNDPGMMSG  MSG('REC0950 - Retail Interest Summary +
                          Extract')  TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/* User Defined Correspondence processing                            */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
 
/*  Access PF/SDMMODPD to determine whether UDC module is on         */
 
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/*  Database error handling                                         */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)
 
/***Check*if*SAR*CER039*is*installed**********************************/                   /*CCB023*/
 
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                */                     /*CCB023*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                */                     /*CCB023*/
/**********  CHGVAR     VAR(&SAR) VALUE('CER039')                  */                     /*CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)*/                    /*CCB023*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)         */                     /*CCB023*/
 
/*  If UDC Module is on and SAR CER039 is installed                  */
 
             CLRPFM     FILE(REINSHPD)
 
/**********  ENDDO                                                 */                     /*CCB023*/
 
             ENDDO
 
/* Clear Extract File                                                */
 
             CLRPFM     FILE(REINSDPD)
 
/* Generate Retail Interest Summary Extract                          */
 
             CALL       PGM(RE0950)
 
/* Check for error return indicator                                  */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             SNDPGMMSG  MSG('RE0950 - Retail Interest Summary Extract +
                          has terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:       SNDPGMMSG  MSG('RE0950 - Retail Interest Summary Extract +
                          has terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
 
             DMPCLPGM
 
             CHGJOB     SWS(XXXXXX11)
 
END: ENDPGM
