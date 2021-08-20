     /*****************************************************************/
     /*                                                               */
     /*  Last Amend No. MD031937           Date 13Jan15               */
     /*  Prev Amend No. AR856737           Date 13Sep11               */
     /*                 ESL044   *Create   Date 01Feb2005             */
     /*                                                               */
     /*****************************************************************/
     /*                                                               */
     /*  MD031937 - Upgrade STP enhancements to BF Midas 2.1          */
     /*  AR856737 - Upgrade STP enhancements to Midas Plus level      */
     /*  ESL044 - Cob load of BIC Plus                                */
     /*                                                               */
     /*****************************************************************/

/* Clear and run take on              */

             CLRPFM     FILE(FTBSCHP0)

             CALL       PGM(FTP0705) PARM(' ')

     /*****************************************************************/
     /* End of MEC1425DB1                                             */
     /*****************************************************************/
