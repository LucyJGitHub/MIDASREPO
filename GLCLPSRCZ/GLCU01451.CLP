/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Transfering MT942 from CAR to CORE CGL013')  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - General Ledger Module                           */
/*                                                                   */
/*       GLCU01451 - Midas GL Transfering MT942 from                 */
/*                   CAR to CORE CGL013                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. EML102  *CREATE    Date 04Dec19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML102 - Upgrade of UNL007 to FB2.1 SP23                    */
/*                UNL007 - Extended Narrative                        */
/*                                                                   */
/*********************************************************************/
/**/
    /***********************************************************************************/
    /*                                                                                 */
    /**** IMPORTANT ***** IMPORTANT ***** IMPORTANT ***** IMPORTANT ***** IMPORTANT ****/
    /*                                                                                 */
    /***********************************************************************************/
    /*      Files MEU942V0, MEA942Y8, SDMGMEX0  are coming from R4 system              */
    /*  it must be copied before the calling of the current program                    */
    /***********************************************************************************/


             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)

/* Create local data area */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)

             CALL       PGM(GLU01451)

             RTVJOBA    SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('PROGRAM GLU01451 IN ERROR ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             CALL       PGM(GLC001436)

 ABNOR:

 RETRN:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDCL:      ENDPGM
