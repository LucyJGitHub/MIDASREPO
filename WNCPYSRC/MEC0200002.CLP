     /*****************************************************************/
     /*                                                               */
     /*  Last Amend No. MD031937           Date 13Jan15               */
     /*  Prev Amend No. AR856737           Date 13Sep11               */
     /*                 EEE065   *Create   Date 01Oct2004             */
     /*                                                               */
     /*****************************************************************/
     /*                                                               */
     /*  MD031937 - Upgrade STP enhancements to BF Midas 2.1          */
     /*  AR856737 - Upgrade STP enhancements to Midas Plus level      */
     /*  EEE065 - FT Payment Routing                                  */
     /*                                                               */
     /*****************************************************************/

/* Copy from back up file to MGOREFP0 */
             CPYF     FROMFILE(MGORSVP0) TOFILE(*LIBL/MGOREFP0) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
     /*****************************************************************/
     /* End of MEC0200002                                             */
     /*****************************************************************/
