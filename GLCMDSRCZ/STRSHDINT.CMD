/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GLC002200)                                              */
/*EXI    TEXT('Midas GL Start Shadow Post Interface')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - GL Shadow Post Interface                            */
/*                                                                   */
/*       STRSHDINT - Start Shadow Post Interface                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2017           */
/*                                                                   */
/*       Last Amend No. CGL027  *CREATE    Date 04Apr17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL027 - Shadow Postings and Sufficient Funds Check         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Start Shadow Post Interface')

             PARM       KWD(INDTAQ) TYPE(DTAQLIB) MIN(1) +
                          PROMPT('Receive Data Queue (read)')

             PARM       KWD(OUTDTAQ) TYPE(DTAQLIB) MIN(1) +
                          PROMPT('Return Data Queue (Sent)')

             PARM       KWD(JOBNAME) TYPE(*NAME) DFT(M_SHD_INT) +
                          PROMPT('Job name')

             PARM       KWD(NBR) TYPE(*DEC) LEN(1) DFT(1) RANGE(1 9) +
                          PROMPT('Number of Jobs')

             PARM       KWD(CRTDTAQ) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Create data +
                          queues')

 DTAQLIB:    QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*CURLIB) +
                          (*LIBL)) PROMPT('Library')
