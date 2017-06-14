/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GLC002210)                                              */
/*EXI    TEXT('Midas GL End Shadow Post Interface')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - GL Shadow Post Interface                            */
/*                                                                   */
/*       ENDSHDINT - End Shadow Post Interface                       */
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
             CMD        PROMPT('End Shadow Post Interface')

             PARM       KWD(INDTAQ) TYPE(DTAQLIB) MIN(1) +
                          PROMPT('Receive Data Queue (read)')

 DTAQLIB:    QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*CURLIB) +
                          (*LIBL)) PROMPT('Library')
