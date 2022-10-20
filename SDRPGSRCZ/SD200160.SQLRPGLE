     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058830
/*STD *  RPGSQLMOD                                                    *                     MD058830
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058830
/*EXI *  TEXT('Midas SD Network Description - Database Update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200160 - Midas SD Network Description Maintenance    *
      *                   (Database Update)                           *
      *                                                               *
      *  Function:  This module updates the files related to a        *
      *             Network Description                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058830           Date 01Oct21               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 251316             Date 05Nov07               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_011, CGL146_027     *
      *                        CGL146_028, CGL146_029, CGL146_030     *
      *                        CGL146_031, CGL146_032                 *
      *  251316 - MT940 not produced in COB.  Additional validation   *
      *           when amending Network description to avoid incorrect*
      *           deletion of record in GLNWKAPD.                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     F*SDNWRKL0* UF A E           K DISK    INFSR(*PSSR) RENAME(@EDREJY:SDNWRKD0)           MD058830
     F**********                           COMMIT                                           MD058830
      ** Midas Message Network Details
      *

     FGLNWKAPD  UF A E           K DISK    INFSR(*PSSR) COMMIT
      ** Midas GL Network Activity Control File
      *

     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR) RENAME(@AHREAU:SDFCTLD0)
     F                                     COMMIT
      ** Midas SD Standing Data Controls
      *
     F/COPY OFCPYSRCZ,CGL146_027                                                              CGL146

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access SDNWRKL0                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

     D*CurFilRcd     E DS                  EXTNAME(SDNWRKPD)                                MD058830
     D CurFilRcd     E DS                  EXTNAME(SDNWKJW0)                                MD058830
      ** Current Network File Record (i.e. state of the record when entering this module)
      *

     D*PrvFilRcd     E DS                  EXTNAME(SDNWRKPD) PREFIX(PRV_)                   MD058830
     D PrvFilRcd     E DS                  EXTNAME(SDNWKJW0) PREFIX(PRV_)                   MD058830
      ** Previous Network File Record (i.e. initial state of the record)
      *

     D*NewFilRcd     E DS                  EXTNAME(SDNWRKPD) PREFIX(NEW_)                   MD058830
     D NewFilRcd     E DS                  EXTNAME(SDNWKJW0) PREFIX(NEW_)                   MD058830
      ** New Network File Record (i.e. new state after amendments)
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
     D/COPY OFCPYSRCZ,CGL146_028                                                              CGL146

      ** Declared variables
      ** ------------------
      *
     D*COPY*OFCPYSRCZ,CGL146_001                                                     CGL146 MD058830

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ActionCode
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_011                                                              CGL146

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Process updating according to the action code
      *
     C                   SELECT

      ** -- Insert a record
      *
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      $InsertRcd

      ** -- Update a record
      *
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      $UpdateRcd

      ** -- Delete a record
      *
     C                   WHEN      ActionCode = 'D'
     C                   EXSR      $DeleteRcd

     C                   ENDSL

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $InsertRcd: Insert a new record                                        *
      *------------------------------------------------------------------------*
     C     $InsertRcd    BEGSR
      *    ----------    ------
      ** Record already exists ==> Error

     C                   IF        NOT *IN27
     C                   MOVE      'USR3989'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Insert the new record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'I'
     C**********         WRITE     SDNWRKD0                                                 MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKBTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDSRVP                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDSRVP                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKXTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
     C/COPY OFCPYSRCZ,CGL146_029                                                              CGL146
      *    ----------    ------
     C     @InsertRcd    ENDSR

      *========================================================================*
      * $UpdateRcd: Update a record                                            *
      *------------------------------------------------------------------------*
     C     $UpdateRcd    BEGSR
      *    ----------    ------
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'USR3990'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'USR3991'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Amend the record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'A'
     C**********         UPDATE    SDNWRKD0                                                 MD058830
     C/EXEC SQL                                                                             MD058830
     C+ update SDNWKXTD set                                                                 MD058830
     C+   EDNETD = :EDNETD                                                                  MD058830
     C+  ,EDLCD  = :EDLCD                                                                   MD058830
     C+  ,EDTYLC = :EDTYLC                                                                  MD058830
     C+  ,EDPROT = :EDPROT                                                                  MD058830
     C+  ,EDM940 = :EDM940                                                                  MD058830
     C+  ,EDM941 = :EDM941                                                                  MD058830
     C+  ,EDM942 = :EDM942                                                                  MD058830
     C+  ,EDM950 = :EDM950                                                                  MD058830
     C+  ,EDAMDS = :EDAMDS                                                                  MD058830
     C+  ,EDENRA = :EDENRA                                                                  MD058830
     C+  ,EDRPSR = :EDRPSR                                                                  MD058830
     C+  ,EDPASS = :EDPASS                                                                  MD058830
     C+  ,EDPASN = :EDPASN                                                                  MD058830
     C+  ,ED0MXL = :ED0MXL                                                                  MD058830
     C+  ,ED0DMS = :ED0DMS                                                                  MD058830
     C+  ,ED0MI1 = :ED0MI1                                                                  MD058830
     C+  ,ED0MI2 = :ED0MI2                                                                  MD058830
     C+  ,ED0MI3 = :ED0MI3                                                                  MD058830
     C+  ,ED0MI4 = :ED0MI4                                                                  MD058830
     C+  ,ED0MI5 = :ED0MI5                                                                  MD058830
     C+  ,ED0MI6 = :ED0MI6                                                                  MD058830
     C+  ,ED1AER = :ED1AER                                                                  MD058830
     C+  ,ED1SER = :ED1SER                                                                  MD058830
     C+  ,ED1AGS = :ED1AGS                                                                  MD058830
     C+  ,ED1SGS = :ED1SGS                                                                  MD058830
     C+  ,ED1AMR = :ED1AMR                                                                  MD058830
     C+  ,ED1SMR = :ED1SMR                                                                  MD058830
     C+  ,ED1MXL = :ED1MXL                                                                  MD058830
     C+  ,ED1GNM = :ED1GNM                                                                  MD058830
     C+  ,ED1RPL = :ED1RPL                                                                  MD058830
     C+  ,ED1RSP = :ED1RSP                                                                  MD058830
     C+  ,ED1MI1 = :ED1MI1                                                                  MD058830
     C+  ,ED1MI2 = :ED1MI2                                                                  MD058830
     C+  ,ED1MI3 = :ED1MI3                                                                  MD058830
     C+  ,ED1MI4 = :ED1MI4                                                                  MD058830
     C+  ,ED1MI5 = :ED1MI5                                                                  MD058830
     C+  ,ED1MI6 = :ED1MI6                                                                  MD058830
     C+  ,ED2AER = :ED2AER                                                                  MD058830
     C+  ,ED2SER = :ED2SER                                                                  MD058830
     C+  ,ED2AGS = :ED2AGS                                                                  MD058830
     C+  ,ED2SGS = :ED2SGS                                                                  MD058830
     C+  ,ED2AMR = :ED2AMR                                                                  MD058830
     C+  ,ED2SMR = :ED2SMR                                                                  MD058830
     C+  ,ED2MXL = :ED2MXL                                                                  MD058830
     C+  ,ED2GNM = :ED2GNM                                                                  MD058830
     C+  ,ED2FNI = :ED2FNI                                                                  MD058830
     C+  ,ED2NIM = :ED2NIM                                                                  MD058830
     C+  ,ED2RPL = :ED2RPL                                                                  MD058830
     C+  ,ED2RSP = :ED2RSP                                                                  MD058830
     C+  ,ED2MI1 = :ED2MI1                                                                  MD058830
     C+  ,ED2MI2 = :ED2MI2                                                                  MD058830
     C+  ,ED2MI3 = :ED2MI3                                                                  MD058830
     C+  ,ED2MI4 = :ED2MI4                                                                  MD058830
     C+  ,ED2MI5 = :ED2MI5                                                                  MD058830
     C+  ,ED2MI6 = :ED2MI6                                                                  MD058830
     C+  ,ED5MXL = :ED5MXL                                                                  MD058830
     C+  ,ED5DMS = :ED5DMS                                                                  MD058830
     C+  ,EDPFRQ = :EDPFRQ                                                                  MD058830
     C+  ,EDRFNP = :EDRFNP                                                                  MD058830
     C+  ,EDRFSD = :EDRFSD                                                                  MD058830
     C+  ,EDRFST = :EDRFST                                                                  MD058830
     C+  ,EDRFSS = :EDRFSS                                                                  MD058830
     C+  ,EDFEXU = :EDFEXU                                                                  MD058830
     C+  ,EDRPNM = :EDRPNM                                                                  MD058830
     C+  ,EDTSNM = :EDTSNM                                                                  MD058830
     C+  ,EDSUID = :EDSUID                                                                  MD058830
     C+  ,EDEXTP = :EDEXTP                                                                  MD058830
     C+  ,EDTRTP = :EDTRTP                                                                  MD058830
     C+  ,EDACNF = :EDACNF                                                                  MD058830
     C+  ,EDMCNW = :EDMCNW                                                                  MD058830
     C+  ,ED0F61 = :ED0F61                                                                  MD058830
     C+  ,ED2F61 = :ED2F61                                                                  MD058830
     C+  ,ED5F61 = :ED5F61                                                                  MD058830
     C+  ,EDF86F = :EDF86F                                                                  MD058830
     C+  ,EDNOLN = :EDNOLN                                                                  MD058830
     C+  ,EDNCLN = :EDNCLN                                                                  MD058830
     C+  ,EDLSEP = :EDLSEP                                                                  MD058830
     C+  ,EDWTXT = :EDWTXT                                                                  MD058830
     C+  ,EDTRLN = :EDTRLN                                                                  MD058830
     C+  ,EDMGLN = :EDMGLN                                                                  MD058830
     C+  ,EDKLSP = :EDKLSP                                                                  MD058830
     C+  ,EDEXET = :EDEXET                                                                  MD058830
     C+  ,EDEXFM = :EDEXFM                                                                  MD058830
     C+  ,EDGVCD = :EDGVCD                                                                  MD058830
     C+  ,EDGVCC = :EDGVCC                                                                  MD058830
     C+  ,EDFSEP = :EDFSEP                                                                  MD058830
     C+  ,EDFXTR = :EDFXTR                                                                  MD058830
     C+  ,EDCONV = :EDCONV                                                                  MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C/COPY OFCPYSRCZ,CGL146_030                                                              CGL146
      *    ----------    ------
     C     @UpdateRcd    ENDSR

      *========================================================================*
      * $DeleteRcd: Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeleteRcd    BEGSR
      *    ----------    ------
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'USR3992'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'USR3993'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Logically delete the record
      *
     C                   EVAL      EDLCD  = AGRDNB
     C                   EVAL      EDTYLC = 'D'
     C**********         UPDATE    SDNWRKD0                                                 MD058830
     C/EXEC SQL                                                                             MD058830
     C+ update SDNWKXTD set                                                                 MD058830
     C+   EDLCD  = :EDLCD                                                                   MD058830
     C+  ,EDTYLC = :EDTYLC                                                                  MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
      *    ----------    ------
     C     @DeleteRcd    ENDSR

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Update the related files and exit from the module          *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Simply exit if something went wrong
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   GOTO      #ExitMod
     C                   ENDIF

      ** Update of GLNWKAPD - Midas GL Network Activity Control File
      *
      ** -- A record should be created if the network allows MT941/42 generation
      **    The creation should not occur for deletion
      *
     C                   IF        ActionCode <> 'D' AND
     C                             (EDM941 = 'Y' OR EDM942 = 'Y')
     C     EDNWRK        CHAIN     GLNWKAD0                           99

     C                   IF        *IN99
     C                   EVAL      MTNWRK = EDNWRK
     C                   EVAL      MTSSTS = 'I'
     C                   WRITE     GLNWKAD0
     C                   ENDIF

     C                   ENDIF

      ** -- An eventual record should be deleted if the network has been deleted
      **    or if the MT941/42 generation indicators were both changed from 'Y'
      **    to 'N'
      *
     C                   IF        ActionCode = 'D' OR
     C**********                   (EDM941 <> 'Y' AND EDM942 <> 'Y')                          251316
     C                             (EDM941 <> 'Y' AND EDM942 <> 'Y' AND                       251316
     C                              EDM940 <> 'Y' AND EDM950 <> 'Y')                          251316
     C     EDNWRK        CHAIN     GLNWKAD0                           99

     C                   IF        NOT *IN99
     C                   DELETE    GLNWKAD0
     C                   ENDIF

     C                   ENDIF

      ** Update of SDFCTLL0 - Midas SD Standing Data Controls
      *
     C     'SDNWRKPD  '  CHAIN     SDFCTLD0                           99

     C                   IF        *IN99
     C                   CLEAR                   SDFCTLD0
     C                   MOVEL     'SDNWRKPD  '  AHFLNM
     C                   ENDIF

     C                   SELECT
     C                   WHEN      ActionCode = 'I'
     C                   ADD       1             AHNOIN
     C                   ADD       1             AHNORC

     C                   WHEN      ActionCode = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC

     C                   OTHER
     C                   ADD       1             AHNOAM
     C                   ENDSL

     C                   IF        *IN99
     C                   WRITE     SDFCTLD0
     C                   ELSE
     C                   UPDATE    SDFCTLD0
     C                   ENDIF

      ** Exit from the module
      *
     C     #ExitMod      TAG
      *    ----------    ------
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF

     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C/COPY OFCPYSRCZ,CGL146_031                                                              CGL146

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

      ** Access file on the specified Key
      *
     C*****NEW_EDNWRK    CHAIN     SDNWRKD0                           27                    MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :CurFilRcd                                                                     MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :NEW_EDNWRK                                                          MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       27                    MD058830
     C                   If        SQLCODE <> 0                                             MD058830
     C                   SETON                                        27                    MD058830
     C                   ENDIF                                                              MD058830
     C/COPY OFCPYSRCZ,CGL146_032                                                              CGL146
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
