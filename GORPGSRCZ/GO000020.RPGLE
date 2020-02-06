     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Initialise zone')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000020 - Initialise zone                                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF005             Date 04Jul11               *
      *                 CUP003             Date 01Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CPK023             Date 13Dec05               *
      *                 CGP009             Date 22Dec04               *
      *                 CUP025  *CREATE    Date 28Nov03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *  CUP003 - Initialise new field on GOOSJSPD.                   *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  CPK023 - Additional initialisation - GOOSJSPD.               *
      *                                     - SDLOCNPD.               *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CUP025 - MidasPlus Bridge changes.                           *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file indicator
      *       31      Record on GPZONEPD not found
      *       32      Record on GOICDTPD not found
      *       69      Read or write errors
      *
     FGPZONEL0  UF A E           K DISK    INFSR(*PSSR)
     FGOICDTL0  UF A E           K DISK    INFSR(*PSSR)
     FGOOSJSPD  UF A E             DISK    INFSR(*PSSR)                                       CPK023
     FSDLOCNL0  UF A E           K DISK    INFSR(*PSSR)                                       CPK023
     F**GPMACBR3  UF A E           K DISK    INFSR(*PSSR)                              CPK023 CBF005
      *
      /EJECT
      *
     D @RUN            S              1
     D LocationKey     S              3    INZ('***')                                         CPK023
     D LocationName    S             30    INZ('Default Global Location Code')                CPK023
      *
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Branch details                                                       CPK023
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CPK023
      *                                                                                       CPK023
      ** Second DS for access programs, long data structure                                   CPK023
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CPK023
      *                                                                                       CPK023
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D*wsUSRP***       S                   like(USRP)                                  CPK023 CBF005
      *
     C     *ENTRY        PLIST
     C                   PARM                    PZone            10
     C                   PARM                    PZoneCode         4
     C                   PARM                    PZoneDesc        50
     C                   PARM                    PAcMvRcvDay       3 0
     C                   PARM                    PMainPrefix       2
     C                   PARM                    PSuppPrefix       2
      *
      * Check if records exist on zone file.
     C     PZone         CHAIN     GPZONEL0                           31
      * If record found then write record ...
     C                   IF        *IN31 = *ON
      *
     C                   EXSR      InitGPZONE
     C                   EVAL      ZOCHTP = 'I'
     C                   WRITE     GPZONED0
      *
      * ... else update record.
     C                   ELSE
      *
     C                   EXSR      InitGPZONE
     C                   EVAL      ZOCHTP = 'A'
     C                   UPDATE    GPZONED0
      *
     C                   ENDIF
      *
      * Check if record exists on zone ICD file.
     C     *blanks       CHAIN     GOICDTL0                           32
     C                   IF        *IN32 = *ON
      * If record not found then write record ...
     C                   EXSR      InitGOICDT
      *
     C                   WRITE     GOICDTD0
      *
      * ... else update record.
     C                   ELSE
     C                   EXSR      InitGOICDT
      *
     C                   UPDATE    GOICDTD0
      *
     C                   ENDIF
      *
      * Check if record exists on on-line synchronisation file.                               CPK023
     C                   EVAL      I#LASTSEQ = '0000000001'                                   CPK023
     C                   EVAL      I#LASTRCV = 'IR00000001'                                   CUP003
     C     1             CHAIN     GOOSJSPD                                                   CPK023
     C                   IF        %FOUND                                                     CPK023
      * If record found then update record ...                                                CPK023
     C                   UPDATE    GOOSJSD0                                                   CPK023
      *                                                                                       CPK023
      * ... else write record.                                                                CPK023
     C                   ELSE                                                                 CPK023
     C                   WRITE     GOOSJSD0                                                   CPK023
      *                                                                                       CPK023
     C                   ENDIF                                                                CPK023
      *
      * Check if default location code exists on SDLOCNPD.                                    CPK023
     C     LocationKey   CHAIN     SDLOCNL0                                                   CPK023
     C                   IF        NOT(%FOUND)                                                CPK023
      * If record not found then write record.                                                CPK023
     C                   EVAL      DVLCCD = LocationKey                                       CPK023
     C                   EVAL      DVLCNM = LocationName                                      CPK023
     C                   EVAL      DVTYLC = 'I'                                               CPK023
     C                   WRITE     @DVREHI                                                    CPK023
     C                   ENDIF                                                                CPK023
      *
      * Enable Global Security; ensure default zone user has a                                CPK023
      *  record on GP Valid action codes                                                      CPK023
     C**********         EXSR      ChkGPMACBRDD                                        CPK023 CBF005
      *                                                                                       CPK023
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * InitGPZONE - Initialise fields on file GPZONEPD               *
      *                                                               *
      * Called by: *main processing                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     InitGPZONE    BEGSR
      *
      * Initialise fields
     C                   EVAL      ZOZONE = PZone
     C                   EVAL      ZOSHTC = PZoneCode
     C                   EVAL      ZODESC = PZoneDesc
     C                   EVAL      ZOMSYS = PMainPrefix
     C                   EVAL      ZOSSYS = PSuppPrefix
      *
     C                   EVAL      ZONJOB = 1
      *
      * Access data from SDBANKPD.
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        ReturnCode        7
     C                   PARM      '*FIRST '     Option            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * If SDBANKPD was blank then initialise fields with blanks and zeros.
     C                   IF        ReturnCode <> '*EMPTY'
     C                   EVAL      ZORDNB = BJRDNB
     C                   EVAL      ZODNWD = BJDNWD
     C                   EVAL      ZOBCCY = BJCYCD
     C                   EVAL      ZOLCD  = BJRDNB
      *
     C                   ELSE
     C                   EVAL      ZORDNB = 0
     C                   EVAL      ZODNWD = 0
     C                   EVAL      ZOBCCY = *blanks
     C                   EVAL      ZOLCD  = 0
     C                   ENDIF
      *
     C                   EVAL      ZOCUSR = USER
      *
     C     EInitGPZONE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InitGOICDT - Initialise fields on file GOICDTPD               *
      *                                                               *
      * Called by: *main processing                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     InitGOICDT    BEGSR
      *
      * Initialise fields
     C                   EVAL      ZNICDT = *blanks
     C                   EVAL      ZNAMRD = PAcMvRcvDay
      *
     C     EInitGOICDT   ENDSR
      *
      /EJECT
      *****************************************************************                CPK023 CBF005
      *****************************************************************                CPK023 CBF005
      **ChkGPMACBRDD*-**Check*Global*Security**************************                CPK023 CBF005
      *****************************************************************                CPK023 CBF005
      **Called*by:**main*processing************************************                CPK023 CBF005
      *****************************************************************                CPK023 CBF005
      **Calls:*None****************************************************                CPK023 CBF005
      *****************************************************************                CPK023 CBF005
      *****************************************************************                CPK023 CBF005
     C**/free***                                                                       CPK023 CBF005
      ***begsr*ChkGPMACBRDD;                                //                         CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      *****//*Enable Global Security                                                   CPK023 CBF005
      *****//*ensure default zone user has a record on GP Valid action codes           CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      *****wsusrp = pmainprefix + 'USER';                   //                         CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      *****setll ('*G00000129':wsusrp) GPMACBR3;            //                         CPK023 CBF005
      *****if*not %equal(GPMACBR3);                         //                         CPK023 CBF005
      **/end-free                                                                      CPK023 CBF005
      **********                                                                       CPK023 CBF005
      **Access*data from SDBRCHPD.                                                     CPK023 CBF005
     C**********         CALL      'AOBRCHR1'                                          CPK023 CBF005
     C**********         PARM      *BLANKS       ReturnCode                            CPK023 CBF005
     C**********         PARM      '*FIRST '     Option                                CPK023 CBF005
     C**********         PARM      *BLANKS       Brch              3                   CPK023 CBF005
     C*****SDBRCH        PARM      SDBRCH        DSSDY                                 CPK023 CBF005
      **********                                            //                         CPK023 CBF005
     C**/free***                                                                       CPK023 CBF005
      **********                                                                       CPK023 CBF005
      *******if*ReturnCode = *blanks                        //                         CPK023 CBF005
      *********and a8brcd <> *blanks;                       //                         CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      *********reci = 'D';                                  //                         CPK023 CBF005
      *********usrp = wsusrp;                               //                         CPK023 CBF005
      *********mgrp = *zero;                                //                         CPK023 CBF005
      *********icde = *blanks;                              //                         CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      *********// Get first branch on SDBANKPD              //                         CPK023 CBF005
      *********brcb = a8brcd;                               //                         CPK023 CBF005
      *********aca1 = 'A';                                  //                         CPK023 CBF005
      *********aca2 = 'E';                                  //                         CPK023 CBF005
      *********lcd = *zero;                                 //                         CPK023 CBF005
      *********chtp = 'A';                                  //                         CPK023 CBF005
      *********indx = '*G00000129';                         //                         CPK023 CBF005
      *********write MACBRDDF;                              //                         CPK023 CBF005
      *******endif;                                         //                         CPK023 CBF005
      *****endif;                                           //                         CPK023 CBF005
      **********                                            //                         CPK023 CBF005
      ***endsr;*                                            //                         CPK023 CBF005
      **/end-free                                                                      CPK023 CBF005
      **********                                                                       CPK023 CBF005
      **/EJECT**                                                                       CPK023 CBF005
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
