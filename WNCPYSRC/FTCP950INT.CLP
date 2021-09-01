/*********************************************************************/
/*  Last Amend No. MD031937           Date 23Jan15                   */
/*  Prev Amend No. AR856737           Date 13Sep11                   */
/*                 PNL011             Date 12Aug05                   */
/*-------------------------------------------------------------------*/
/*  MD031937 - Upgrade STP enhancements to BF Midas 2.1              */
/*  AR856737 - Upgrade STP enhancements to Midas Plus level          */
/*  PNL011 -  Changes to dealing rates upload                        */
/*********************************************************************/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PNL011) TYPE(*CHAR) LEN(1)
