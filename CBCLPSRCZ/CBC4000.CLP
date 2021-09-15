/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB COB Scheduler Menu')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4000 - Midas CB COB Scheduler Menu                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 20Mar12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM

/* Call Scheduler Menu */
             OVRDBF     FILE(SDCURRL1) SHARE(*NO)
             OVRDBF     FILE(SDBRCHL1) SHARE(*NO)
             CALL       PGM(CB4000)
             DLTOVR     FILE(SDCURRL1)
             DLTOVR     FILE(SDBRCHL1)

             ENDPGM
