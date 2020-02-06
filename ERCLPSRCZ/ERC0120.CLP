/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas @24 KWG display transmission file history')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0120 - Midas @24 KWG display transmission file history   */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008.')
 
/** Override transmission information file */
             OVRDBF     FILE(ERTINFL0) OVRSCOPE(*JOB) SHARE(*NO)
 
/** Call response file renamer */
             CALL       PGM(ER000140)
 
/** Call response file receiver */
             CALL       PGM(ER000110)
 
/** Call history display program */
             CALL       PGM(ER000120)
 
/** Delete override */
             DLTOVR     FILE(ERTINFL0) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
