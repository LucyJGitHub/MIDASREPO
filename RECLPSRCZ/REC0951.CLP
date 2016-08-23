/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Retail Interest Summary Report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0951 - Retail Interest Summary Report                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG23578 *CREATE   Date 24Mar09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23578 - To generate Retail Interest Summary              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&PNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSEQ) TYPE(*DEC) LEN(5)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGJOB     SWS(00000000)
 
             /* GENERATE RETAIL INTEREST SUMMARY REPORT */
 
             CALL       PGM(RE0951)
 
             /* CHECK FOR ERROR RETURN INDICATOR */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             SNDPGMMSG  MSG('RE0951 - Retail Interest Summary Report +
                          has terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:       SNDPGMMSG  MSG('RE0951 - Retail Interest Summary Report +
                          has terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
 
END: ENDPGM
