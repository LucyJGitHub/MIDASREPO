/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FN Takeon Trades for Consolidated brch 2 & 3')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       A1C008008 - Midas FN Takeon Trades for Consolidated brch    */
/*                     Brch 2 & 3                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. BA1008  *CREATE    Date 01Jun21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BA1008 - Replication of Trades to consolidated branches     */
/*                                                                   */
/*********************************************************************/
             PGM

/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
             DCL        (&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        (&BA1008) TYPE(*CHAR) LEN(1) VALUE(' ')

/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
             CHGJOB     SWS(00000000)

             STRCMTCTL  LCKLVL(*ALL)

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)

/* Access Switchable Features file to see if BA1008  present */

             CALL       (AOSARDR0) PARM(&PRTCD '*VERIFY' 'BA1008')
             IF         (&PRTCD *EQ ' ') (CHGVAR (&BA1008) VALUE('Y'))

/* If the BA1008 Feature is present */

             IF         (&BA1008 *EQ 'Y') THEN(DO)
                   CALL       PGM(A1008008)

             ENDDO

             ENDCMTCTL
             DLTDTAARA  DTAARA(LDA)

             ENDPGM
