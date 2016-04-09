/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC00040)                                               */
/*EXI    TEXT('Midas UT Error Codes Collector Command')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       MIERRCOL - Error Codes Collector Command                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2011           */
/*                                                                   */
/*       Last Amend No. CBF011  *CREATE    Date 04Jul11              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CBF011 - BF Infrastructure: Error Message Handling          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Midas Error Codes Collector')
 
             PARM       KWD(LIBLST) TYPE(*CHAR) LEN(10) MIN(1) +
                          MAX(10) PROMPT('Library List')
 
             PARM       KWD(TOPPGM) TYPE(TOPPGMFLDS) MIN(1) MAX(5) +
                          PROMPT('Top-Level Program')
 TOPPGMFLDS: QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(20) MIN(1) PROMPT('Error +
                          Field Name')
             QUAL       TYPE(*NAME) LEN(20) MIN(1) PROMPT('Warning +
                          Error Field Name')
             QUAL       TYPE(*NAME) LEN(20) MIN(1) PROMPT('Field in +
                          Error')
             QUAL       TYPE(*NAME) LEN(20) MIN(1) PROMPT('Field in +
                          Warning')
             QUAL       TYPE(*NAME) LEN(50) MIN(0) PROMPT('Message +
                          File Field')
             QUAL       TYPE(*NAME) LEN(50) MIN(0) PROMPT('Message +
                          File Name')
             QUAL       TYPE(*NAME) LEN(10) MIN(0) PROMPT('API Field')
             QUAL       TYPE(*NAME) LEN(10) MIN(0) PROMPT('API Name')
