/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Input cycle termination clear up')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0403 - I/C Termination Clear Up                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1089863          Date 19Feb13              */
/*                      CCB023             Date 06Aug12              */
/*                      AR823326           Date 24Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CSD006             DATE 05Jun01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             DATE 02JUN99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      126471             DATE 04DEC97              */
/*                      110242             DATE 07NOV96              */
/*                      099584             DATE 22APR96              */
/*                      CSC002             DATE 14MAR96              */
/*                      098074             DATE 15JAN96              * *099584*/
/***********************098279             DATE 15JAN96              * *099584*/
/*                      S01408             DATE 19JUN95              */
/*                      084533             DATE 15MAR95              */
/*                      077319             DATE 01MAR95              */
/*                      S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1089863 - Merging issues of 2.0 and 2.1 releases          */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       AR823326 - SFC0521 went on LCKW status due to file MUSER is */
/*                  being locked by RCFMONITOR job. RCFMONITOR is not*/
/*                  required for this component. (Child: AR823327)   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CSD006 - Market Data Feed                                   */
/*       CCB009 - Journal files throughout close of business         */
/*       CGL009 - Midas-Fontis IAT/TPP Interface                     */
/*       126471 - TRMSAV not being submitted if CSC002 installed.    */
/*                Amend fix 099584 - TRMSAV should be submitted by   */
/*                this component, but only if CSC002 is switched on. */
/*                CSC002 saves database and receivers to same tape.  */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       099584 - Job TRMSAV should not be submitted as this is done */
/*                in SCC1711 - complete fix 098074                   */
/*              - Change incorrectly annotated fix 098074            */
/*       CSC002 - Submit TRMSAV if CSC002 installed.                 */
/*       098074 - Remove SBMJOB of TRMSAV as this is done in SCC1711 *  099584*/
/********098279*-*Remove*SBMJOB*of*TRMSAV*as*this*is*done*in*SCC1711 *  099584*/
/*       S01408 - Core hook added SCC0403MP1                         */
/*       084533 - Monitor for ACCNTAB being empty                    */
/*       077319 - MONMSG for empty ACCNTA* files when doing CPYF.    */
/*       S01495 - COB Enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  Initial processing                                              */
/**/
/**********  DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)            */                     /*CCB023*/
/**********  DCL        VAR(&LIB) TYPE(*CHAR) LEN(8) VALUE('  XLIB  ')*/                  /*CCB023*/
/************DCL********VAR(&SAVD) TYPE(*CHAR) LEN(4)              */ /*099584*/
/************DCL********VAR(&JNSTAT) TYPE(*CHAR) LEN(200)          */ /*099584*/
/************DCL********VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */ /*099584*/
/**********  DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)             */                     /*CCB023*/
/**********  DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)             */                     /*CCB023*/
/**********  DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)             */                     /*CCB023*/
/**********  DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)         */                     /*CCB023*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')   */                     /*CCB023*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')*/                  /*CCB023*/
/**********  DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)             */                     /*CCB023*/
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)             /*S01435*/
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/              /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */              /*CCB009 CCB023*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)           */              /*CCB009 CCB023*/
/*/COPY WNCPYSRC,SCC0403003                                          */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('I/C Termination clear up') TOMSGQ(MOPERQ)
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.****************************/              /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                         */              /*CCB009 CCB023*/
/**/
/** Check that the required data areas exist                       */
/**                                                                */
/** JNSTAT                                                         */
/**/
/************CHKOBJ     OBJ(JNSTAT) OBJTYPE(*DTAARA)             */ /*099584*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                  */ /*099584*/
/**************CHGVAR     VAR(&SMSG) VALUE('Job terminated +     */ /*099584*/
/**************             - JNSTAT not found ')                */ /*099584*/
/**************SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)              */ /*099584*/
/**************CHGJOB     SWS(XXXXXX11)                          */ /*099584*/
/**************GOTO       CMDLBL(ENDPGM)                         */ /*099584*/
/************ENDDO                                               */ /*099584*/
/**/
/***MMOD************************************************************/                     /*CCB023*/
/**/
/**********  CHKOBJ     OBJ(MMOD) OBJTYPE(*DTAARA)                 */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                    */                     /*CCB023*/
/**********    CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                            - MMOD not found ')                    */                     /*CCB023*/
/**********    SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)                */                     /*CCB023*/
/**********    CHGJOB     SWS(XXXXXX11)                            */                     /*CCB023*/
/**********    GOTO       CMDLBL(ENDPGM)                           */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
/**/
/** SDSTAT                                                         */
/**/
/************CHKOBJ     OBJ(SDSTAT) OBJTYPE(*DTAARA)              */ /*099584*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                   */ /*099584*/
/**************CHGVAR     VAR(&SMSG) VALUE('Job terminated +      */ /*099584*/
/********************       - SDSTAT not found ')                 */ /*099584*/
/**************SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)               */ /*099584*/
/**************CHGJOB     SWS(XXXXXX11)                           */ /*099584*/
/**************GOTO       CMDLBL(ENDPGM)                          */ /*099584*/
/************ENDDO                                                */ /*099584*/
/**/
/***Access*PF/SDMMODPD*to*determine*which*modules*are*live***/                            /*CCB023*/
/**/
/**********  CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)       */                     /*CCB023*/
/**/
/***Database*error*handling*****************************************/                     /*CCB023*/
/**/
/**********  IF         COND(&RTCD *NE '       ') THEN(DO)         */                     /*CCB023*/
/**********    SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)              */                     /*CCB023*/
/**********    GOTO       CMDLBL(ABNOR)                            */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
/**/
/************RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)             */ /*099584*/
/************CHGVAR     VAR(&SAVD) VALUE(%SUBSTRING(&JNSTAT 49 4)) */ /*099584*/
/**************                                                    */ /*099584*/
/************RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             */ /*099584*/
/**************                                                    */ /*099584*/
/************IF         COND(&SAVD *EQ 'TAPE') THEN(GOTO +         */ /*099584*/
/**************           CMDLBL(SUBMIT))                          */ /*099584*/
/************IF         COND(&SAVD *EQ 'DKTE') THEN(GOTO +         */ /*099584*/
/**************           CMDLBL(SUBMIT))                          */ /*099584*/
/**/
/************GOTO       CMDLBL(SARCHK)                                 *126471*/
/************                                                          *126471*/
/***Check*that the SAVEJOBD job description exists                     *126471*/
/************                                                          *126471*/
/*SUBMIT:******CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) +              */ /*099584*/
/********************     VALUE(%SUBSTRING(&SDSTAT 6 2))           */ /*099584*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC0403MP1                                          */
                                                                      /*S01408*/
/************CHKOBJ     OBJ(&LIB/SAVEJOBD) OBJTYPE(*JOBD)          */ /*099584*/
/************MONMSG     MSGID(CPF9801) EXEC(DO)                    */ /*099584*/
/**************CHGVAR     VAR(&SMSG) VALUE('TRMSAV not submitted + */ /*099584*/
/********************       - SAVEJOBD job description not found ')*/ /*099584*/
/**************SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)                */ /*099584*/
/**************CHGJOB     SWS(XXXXXX11)                            */ /*099584*/
/**************GOTO       CMDLBL(ENDPGM)                           */ /*099584*/
/************ENDDO                                                 */ /*099584*/
/************SBMJOB     JOB(TRMSAV) JOBD(&LIB/SAVEJOBD) RQSDTA('CALL + *098074*/
/******************       SDC1797') MSGQ(MOPERQ) RTGDTA(*JOBD)     */ /*098074*/
/* */                                                                 /*CSC002*/
/* Submit TRMSAV here as receivers are now avaliable */               /*CSC002*/
/* */                                                                 /*CSC002*/
/* */                                                                 /*CSC002*/
/***Check*if*switchable*feature*installed***************************/              /*CSC002 CCB023*/
/* */                                                                 /*CSC002*/
/**********  CHGVAR     VAR(&SRTCD) VALUE('       ')               */              /*CSC002 CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */              /*CSC002 CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('CSC002')                */              /*CSC002 CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                */              /*CSC002 CCB023*/
/* */                                                                 /*CSC002*/
/***Error*if*not*blanks*or*no*record********************************/              /*CSC002 CCB023*/
/* */                                                                 /*CSC002*/
/**********  IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */              /*CSC002 CCB023*/
/**********  SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                          TOMSGQ(MOPERQ)                           */              /*CSC002 CCB023*/
/**********  GOTO       CMDLBL(ABNOR)                              */              /*CSC002 CCB023*/
/**********  ENDDO                                                 */              /*CSC002 CCB023*/
/* */                                                                 /*CSC002*/
/* Submit TRMSAV job */                                               /*CSC002*/
/* */                                                                 /*CSC002*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)        */              /*CSC002 CCB023*/
/************SBMJOB     CMD(CALL PGM(SDC1797)) JOB(TRMSAV) +          /*110242*/
/*************            JOBD(&LIB/SAVEJOBD) RTGDTA(*JOBD) +         /*110242*/
/*************            MSGQ(MOPERQ) */                     /*CSC002  110242*/
/************SBMJOB     CMD(CALL PGM(SDC1797)) JOB(TRMSAV) +
/************             JOBD(&LIB/SAVEJOBD) RTGDTA(*JOBD) +
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)         /*110242 126471*/
/************SBMJOB     CMD(CALL PGM(SDC1797)) JOB(TRMSAV) +                              /*CPK014*/
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD) +                                  /*CPK014*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*126471*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(SDC1797)) JOB(TRMSAV) +                              /*CSC023*/
/************             JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +                      /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CPK014*/ /*CSC023*/
/**********  SBMJOB     CMD(CALL PGM(SDC1797)) JOB(TRMSAV) +
                          JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)  */              /*CCB023 CSC023*/
/**********  ENDDO                                                 */              /*CSC002 CCB023*/
                                                                      /*CSC002*/
/**/
/***Check*if*SAR*installed******************************************/                     /*CCB023*/
/**/
/***SARCHK:      CHGVAR     VAR(&SRTCD) VALUE('       ')           */                     /*CCB023*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')               */                     /*CCB023*/
/**********  CHGVAR     VAR(&SSARD) VALUE('S01359')                */                     /*CCB023*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                */                     /*CCB023*/
/**/
/***Error***********************************************************/                     /*CCB023*/
/**/
/**********  IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */                     /*CCB023*/
/**********  SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') TOMSGQ(MOPERQ)*/                  /*CCB023*/
/**********  GOTO       CMDLBL(ABNOR)                              */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
/*/COPY WNCPYSRC,SCC0403004                                          */
/**/
/** SAR installed                                                  */
/** Daily balance proof report                                     */
/**/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)        */                     /*CCB023*/
/**********     CPYF       FROMFILE(ACCNTAA) TOFILE(OACNTAA) +
                           MBROPT(*REPLACE)                        */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(OACNTAA))                        */              /*077319 CCB023*/
/**********     CPYF       FROMFILE(ACCNTAB) TOFILE(OACNTAB) +
                           MBROPT(*REPLACE)                        */                     /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(OACNTAB))                        */              /*084533 CCB023*/
/**********     CPYF       FROMFILE(ACCNTAC) TOFILE(OACNTAC) +
                           MBROPT(*REPLACE)                        */                     /*CCB023*/
/**********  ENDDO                                                 */                     /*CCB023*/
/*/COPY WNCPYSRC,SCC0403007                                          */
/**/
/** Message management - Drop historic messages                    */
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SUBSTRING(&MMOD 56 1) *EQ 'Y') THEN(DO)
                CHGJOB     SWS(XXXXXX00)
/**/                                                                  /*CGL009*/
/***Check*if*CGL009*installed***/                                                  /*CGL009 CCB023*/
/**/                                                                  /*CGL009*/
/**********     CHGVAR     VAR(&SRTCD) VALUE('       ')            */              /*CGL009 CCB023*/
/**********     CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')            */              /*CGL009 CCB023*/
/**********     CHGVAR     VAR(&SSARD) VALUE('CGL009')             */              /*CGL009 CCB023*/
/**********     CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                */              /*CGL009 CCB023*/
/**/                                                                  /*CGL009*/
/***Error**/                                                                       /*CGL009 CCB023*/
/**/                                                                  /*CGL009*/
/**********     IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */              /*CGL009 CCB023*/
/**********        SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR')  +
                                               TOMSGQ(MOPERQ)      */              /*CGL009 CCB023*/
/**********        GOTO       CMDLBL(ABNOR)                        */              /*CGL009 CCB023*/
/**********     ENDDO                                              */              /*CGL009 CCB023*/
/**/                                                                  /*CGL009*/
/** CGL009 installed */                                               /*CGL009*/
/**/                                                                  /*CGL009*/
/**********     IF         COND(&SRTCD *EQ '       ') THEN(DO)     */              /*CGL009 CCB023*/
/**********        CALL       PGM(GLC2829)                         */              /*CGL009 CCB023*/
/**********        IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                                CMDLBL(ABNOR))                     */              /*CGL009 CCB023*/
/**********     ENDDO                                              */              /*CGL009 CCB023*/
/**/
                CALL       PGM(MEC0200)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
/*/COPY WNCPYSRC,SCC0403002                                          */
/**/
/** Message management - Set OFF today's work indicator            */
/**/
                CHGJOB     SWS(XXXXXX00)
                CALL      PGM(ME0210)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
/*/COPY WNCPYSRC,SCC0403001                                          */
             ENDDO
/**/
/* Convert SWIFT BIC Bank File */
/* */
             CALL       PGM(MEC1410) PARM(&RTN_CODE)
             IF         COND(&RTN_CODE *NE '       ') THEN(GOTO +
                            CMDLBL(ABNOR))
/**/
/** If swift direct link clear files as ICD                        */
/**/
             IF         COND(%SST(&MMOD 18 1) *EQ 'Y') THEN(DO)
               CALL       PGM(MSC0505)
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                            CMDLBL(ABNOR))
               IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)
                 CHGJOB     SWS(XXXX0XXX)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
             ENDDO
/*/COPY WNCPYSRC,SCC0403008                                          */
/**/
/* Check to see if report distribution program is active */
/**/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDPGM))
/**/
/* If not active, submit report distribution and deallocate dtaara */
/**/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/              /*CCB009 CCB023*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */              /*CCB009 CCB023*/
/**/
/* Journal the RCF files for the distribution job RCFMONITOR */
/**/
/*/COPY WNCPYSRC,SCC0403005                                          */
/**********  STRJRNPF   FILE(FCSFNOPD) JRN(CBJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF7030)                             */                     /*CCB023*/
/**********  STRJRNPF   FILE(MAARCDPD) JRN(CBJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF7030)                             */                     /*CCB023*/
/**********  STRJRNPF   FILE(MAEXPTPD) JRN(CBJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF7030)                             */                     /*CCB023*/
/**********  STRJRNPF   FILE(MAMWRKPD) JRN(CBJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF7030)                             */                     /*CCB023*/
/**********  STRJRNPF   FILE(MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                         */                     /*CCB023*/
/**********  MONMSG     MSGID(CPF7030)                             */                     /*CCB023*/
/**********  ENDDO                                                 */              /*CCB009 CCB023*/
/*/COPY WNCPYSRC,SCC0403006                                          */
/**/
/***Check*if*CSD006*installed***/                                                  /*CSD006 CCB023*/
/**/                                                                  /*CSD006*/
/**********     CHGVAR     VAR(&SRTCD) VALUE('       ')            */              /*CSD006 CCB023*/
/**********     CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')            */              /*CSD006 CCB023*/
/**********     CHGVAR     VAR(&SSARD) VALUE('CSD006')             */              /*CSD006 CCB023*/
/**********     CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                */              /*CSD006 CCB023*/
/**/                                                                  /*CSD006*/
/***Error**/                                                                       /*CSD006 CCB023*/
/**/                                                                  /*CSD006*/
/**********     IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */              /*CSD006 CCB023*/
/**********        SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR')  +
                                               TOMSGQ(MOPERQ)      */              /*CSD006 CCB023*/
/**********        GOTO       CMDLBL(ABNOR)                        */              /*CSD006 CCB023*/
/**********     ENDDO                                              */              /*CSD006 CCB023*/
/**/                                                                  /*CSD006*/
/** CSD006 installed */                                               /*CSD006*/
/**/                                                                  /*CSD006*/
/**********     IF         COND(&SRTCD *EQ '       ') THEN(DO)     */              /*CSD006 CCB023*/
/**********     CHGVAR     VAR(&RTCD) VALUE('       ')             */              /*CSD006 CCB023*/
/**********        CALL       PGM(SDMDFHDL) PARM(&RTCD)            */              /*CSD006 CCB023*/
/**********        IF         COND(&RTCD *NE '       ') THEN(GOTO +
                                CMDLBL(ABNOR))                     */              /*CSD006 CCB023*/
/**********     ENDDO                                              */              /*CSD006 CCB023*/
/**/
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +                                  /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) +                                  /*CPK014*/
/************             JOBQ(FCJOBQ) OUTQ(*JOBD) RTGDTA(*JOBD) +                        /*CPK014*/
/************             INLLIBL(*JOBD)                                                  /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +           */         /*AR823326 AR1089863*/
/**********               JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +*/       /*AR823326 AR1089863*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +  */         /*AR823326 AR1089863*/
/**********               INLLIBL(*JOBD)                           */  /*CPK014 AR823326 AR1089863*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                               /*AR1089863*/
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/** Global error processing                                        */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('I/C Termination clear up ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:     MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
