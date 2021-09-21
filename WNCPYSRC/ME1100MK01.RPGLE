      *****************************************************************
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 MKFX01             Date 23Jan06               *
      *                 PNL002  *Create    Date 22Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  MKFX01 - Processing of field :24: added.                     *
      *  PNL002 - Changes to MultiCash interface.                     *
      *                                                               *
      *****************************************************************
      *
      */OMITEND                                                                               PNL002
     D*****               TFLD    1  60 10   TPRM    5                                 PNL002 MKFX01
     D*****               TFLD    1  61 10   TPRM    5                                        MKFX01
     D*****               TFLD    1  74 10   TPRM    5                                 MKFX01 CSW209
     D TFLD            S             10    DIM(75) CTDATA PERRCD(1)                        AR8567373
     D TPRM            S              5    DIM(75) ALT(TFLD)                               AR8567373
      *
      * End of /COPY ME1100MK01                                       *
      *****************************************************************
