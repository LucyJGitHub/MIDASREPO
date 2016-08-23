/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Init new flds of amended LE files (T2)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       LEC0011I - LE Initialisation Program                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 220102             Date 28Jul03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 205409             Date 28Jul03              */
/*                      208242             Date 27Aug02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CLE010 *CREATE     Date 02May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       220102 - Correct case must be used for system values        */
/*       205409 - Add an extra parameter to the call to LE0011 to    */
/*                control whether all PCRF's are reset regardless of */
/*                whether they already contain values (default 'N')  */
/*       208242  - Add initialisation of the LoanNbrAutoAllocate     */
/*                 system value to this program.                     */
/*       CLE010  - Customer Lending Enhancements - Loan Manager      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSVALKEY) TYPE(*CHAR) LEN(20)                               /*208242*/
             DCL        VAR(&NEWSYSVAL) TYPE(*CHAR) LEN(200)                              /*208242*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*208242*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)                                      /*208242*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  IF         COND(&MODE *NE '3') THEN(CALL PGM(LE0011)) */                     /*208242*/
                                                                                          /*208242*/
             CHGVAR     VAR(&SYSVALKEY) +
                          VALUE('LoanNbrAutoAllocate')                                    /*208242*/
             CHGVAR     VAR(&NEWSYSVAL) VALUE('Y')                                        /*208242*/
             CHGVAR     VAR(&SUPPUPD) VALUE('SUPPRESS')                                   /*208242*/
                                                                                          /*208242*/
/************IF         COND(&MODE *EQ '1') THEN(DO)  */                       /*208242*/ /*220102*/
             IF         COND(&MODE *NE '3') THEN(DO)                                      /*208242*/
                                                                                          /*208242*/
/***************CALL       PGM(LE0011)                                         /*208242*/ /*205409*/
                CALL       PGM(LE0011)  PARM('N')                                         /*205409*/
                                                                                          /*208242*/
/* Call program to update the SDSVALPD file */                                            /*208242*/
                                                                                          /*208242*/
                CALL       PGM(SDC009510) PARM(&SYSVALKEY &NEWSYSVAL +
                             &SUPPUPD)                                                    /*208242*/
                                                                                          /*208242*/
                RTVJOBA    SWS(&SWS)                                                      /*208242*/
                                                                                          /*208242*/
                IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(DO)                         /*208242*/
                   GOTO       CMDLBL(ABNOR)                                               /*208242*/
                ENDDO                                                                     /*208242*/
                                                                                          /*208242*/
             ENDDO                                                                        /*208242*/
                                                                                          /*208242*/
/************IF         COND(&MODE *EQ '2') THEN(DO)                           /*208242*/ /*220102*/
/**********     CALL       PGM(LE0011) */                                      /*208242*/ /*205409*/
/**********     CALL       PGM(LE0011) PARM('N')                               /*205409*/ /*220102*/
/************ENDDO                                                             /*208242*/ /*220102*/
                                                                                          /*208242*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
             ELSE       CMD(DO)
                CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
                CHGJOB     SWS(XXXXXX00)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Program LEC0011I ended abnormally')   +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
