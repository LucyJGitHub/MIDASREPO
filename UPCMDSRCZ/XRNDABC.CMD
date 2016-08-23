/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(LEC000498)                                              */
/*EXI    TEXT('Midas Run Lending Available Balance Check')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       XRNDABC - Generate Random Repayment Keys for PDP            */
/*                 Available Balance Computation                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2014           */
/*                                                                   */
/*       Last Amend No. CLE164 *CREATE     Date 18Aug14              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE164 - CLE134 Enhancement F (Repayment Methodology)       */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Available Balance Computation')
 
             PARM       KWD(ITER) TYPE(*DEC) LEN(5 0) DFT(1) RANGE(1 +
                          99999) PROMPT('Number of Iterations')
 
             PARM       KWD(JOBN) TYPE(*CHAR) LEN(10) DFT(LEC000498) +
                          PROMPT('Job Name')
 
             PARM       KWD(RUNT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(1) VALUES(1 2) PROMPT('(1) +
                          Interactive (2) Submit Job')
 
             PARM       KWD(RAND) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Generate +
                          Random Values ?')
 
