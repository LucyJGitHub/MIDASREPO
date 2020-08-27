      *****************************************************************                       HUT106
      *  Midas - Copy member for FTOPAYVU                             *                       HUT106
      *                                                               *                       HUT106
      *  FTOPAYVUF1 - FT Outgoing Payments validate and update        *                       HUT106
      *                                                               *                       HUT106
      *  Last Amend No. MD056457           Date 09Aug20               *                       HUT106
      *  Prev Amend No. HUT106 *CREATE     Date 09Aug20               *                       HUT106
      *                                                               *                       HUT106
      *---------------------------------------------------------------*                       HUT106
      *                                                               *                       HUT106
      *  MD056457 - FISC Code details not expanding to Customer Name  *                       HUT106
      *            on Inputs fields. Expand scope of HUT106           *                       HUT106
      *  HUT106 - Allow FISC Bank Reference to be entered in SWIFT ID *                       HUT106
      *           Field                                               *                       HUT106
      *                                                               *                       HUT106
      *****************************************************************                       HUT106
     FSDCNSTL2  IF   E           K DISK    INFSR(*PSSR)                                       HUT106
     F                                     RENAME(@CNSTLD:SDCNSTF)                            HUT106
     F                                     PREFIX(F_)                                         HUT106
      *****************************************************************                       HUT106
      * End of /COPY FTOPAYVUF1                                       *                       HUT106
      *****************************************************************                       HUT106
