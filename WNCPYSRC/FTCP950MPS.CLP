/*********************************************************************/
/*  Last Amend No. MD31937            Date 23Jan15                   */
/*  Last Amend No. AR856737           Date 13Sep11                   */
/*  Last Amend No. PNL011             Date 12Aug05                   */
/*-------------------------------------------------------------------*/
/*  MD31937  - Upgrade STP enhancements to BF Midas 2.1              */
/*  AR856737 - Upgrade STP enhancements to Midas Plus level          */
/*  PNL011 -  Changes to dealing rates upload                        */
/*********************************************************************/

/* Access switchable features file to see if feature PNL011     */
/* is installed  */

             CHGVAR     VAR(&SARD) VALUE('PNL011')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPTN &SARD &FMT)
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&PNL011) VALUE('Y'))

