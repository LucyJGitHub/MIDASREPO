/*********************************************************************/
/*  Last Amend No. MD031937           Date 23Jan15                   */
/*  Prev Amend No. AR856737           Date 13Sep11                   */
/*                 PNL011   *CREATE   Date 12Aug05                   */
/*-------------------------------------------------------------------*/
/*  MD031937 - Upgrade STP enhancements to BF Midas 2.1              */
/*  AR856737 - Upgrade STP enhancements to Midas Plus level          */
/*  PNL011 -  Changes to dealing rates upload                        */
/*********************************************************************/
             IF         COND(&PNL011 = 'Y') THEN(DO)
             CALL       PGM(SDP047) PARM(&RTN_CODE &INPEOD)
             ENDDO
