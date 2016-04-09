/*STD    CLPBASE                                                     */
/*EXI    TEXT('RE Number of Retail Interest Statements stored')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0952 - Retail store number of statements                 */
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
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             SNDPGMMSG  MSG('REC0952 - Store number of retail +
                          interest statements') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/* Clear the output file                                             */
 
             CLRPFM     FILE(RENOISPD)
 
/* Generate the number of statements file                            */
 
             CALL       PGM(RE0952)
 
/* Check for returned error                                          */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             SNDPGMMSG  MSG('RE0952 - Number of retail interest +
                          statements storage terminated +
                          abnormally') TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ERROR:      SNDPGMMSG  MSG('RE0952 - Store number of interest +
                          statements has terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
 
             DMPCLPGM
 
             CHGJOB     SWS(XXXXXX11)
 
END: ENDPGM
