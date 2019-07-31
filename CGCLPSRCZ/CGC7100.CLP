/*STD    CLPBASE                                                     */
/*EXI    TEXT('RE Audit Letter Selection')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7100 - CG Audit Letter History Maintenance               */
/*                 (Input Cycle Component)                           */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      CER041  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER041 - Audit Letters Correspondence                       */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
/*                                                                   */
/* Declare variables                                                 */
/*                                                                   */
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('CER041')
/*                                                                   */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
 
/*                                                                   */
/* Global Monitor Message */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/*                                                                   */
/* Access to available SAR CER041 file */
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/*                                                                   */
/* If found, do                                                      */
             IF         COND(&SRTCD *EQ '        ') THEN(DO)
             CALL       PGM(CG7100)
             ENDDO
/*                                                                   */
/*program ends here                                                  */
ABNORMAL:
             ENDPGM
