/*********************************************************************/
/*                                                                   */
/*       REC3763003 - LUC114 - Switchability   REC3763               */
/*                                                                   */
/*       (c) Finastra International Banking Systems Ltd. 2019        */
/*                                                                   */
/*       Last Amend No. LUC114             Date 24Jan19              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC114 - Change Layout of Interest Capitalization Report    */
/*                                                                   */
/*********************************************************************/
/* Check if LUC114 is enabled. */

             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('LUC114')
             CHGVAR     VAR(&LUC114) VALUE('N')

             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)

             IF COND(&PRTCD *EQ '       ') THEN(DO)
             CHGVAR     VAR(&LUC114) VALUE('Y')
             ENDDO

             IF         COND(&LUC114 *EQ 'Y') THEN(DO)
             OVRPRTF    FILE(XX3764DC) TOFILE(*LIBL/XX3764DC) +
                          SPLFNAME(RE3764DC)
             CALL       PGM(XX3763) PARM(&BJLANG)
             ENDDO
             ELSE       CMD(DO)
/*********************************************************************/
/* End of hook REC3763003                                            */
/*********************************************************************/
