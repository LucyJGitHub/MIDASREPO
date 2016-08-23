     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Classification Codes Maint - Detl')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000201 - Classification Codes Maintenance                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD036917A          Date 20Jan16               *
      *  Prev Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD036917A - I/o error during add                             *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      *
      ** +--------------------------------------+
      ** ¦ File and Screen Formats              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
      *
      ** Maintenance Screen Display
     FSD000201DFCF   E             WORKSTN INFSR(*PSSR)
     F
 
      ** Classification Codes File - Update
     F***SDFATCL0  UF   E           K DISK    RENAME(SDFATCD0:FCLSU)                       MD036917A
     FSDFATCL0  UF A E           K DISK    RENAME(SDFATCD0:FCLSU)                          MD036917A
 
      ** Classification Codes File - Output
     F***SDFATCL1  O    E             DISK                                                 MD036917A
 
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS ICD retrieval
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, Long Data Structure
     D FatCDS        E DS                  EXTNAME(SDFATCPD)
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
      ** Job name
     D PSJobName             244    253
      ** User name
     D PSUser                254    263
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
     D Actn            S              1A
     D Mode            S              7A
     D RetCode         S              7A
     D ClsCode         S              5A
      *
     D PJob            S             10
     D PUser           S             10
     D Recursive       S              1    INZ('N')
      *
     D ScrLvl          S              1  0 INZ(1)
     D Proceed         S              1  0 INZ(0)
     D ValErr          S              1  0 INZ(1)
     D Action          S              7A
     D ReUseCode       S              1A   INZ('N')
      *
     D ZAPGM           S             10    INZ(*Blanks)
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    Actn
     C                   PARM                    Mode
     C                   PARM                    RetCode
     C                   PARM                    ClsCode
 
 
     C                   EXSR      Init
 
      ** Pre-validation for Create Actn
     C                   IF        Actn  = 'I'
     C                   EXSR      InpValCode
 
     C                   ELSEIF    Actn = 'A' or Actn = 'D'
      ** Check if classifcation is active
     C                   EXSR      ValClsCode
     C                   IF        ValErr = 1
     C                   GOTO      EndPgm
     C                   ENDIF
     C                   ENDIF
 
      ** Display Details Screen (Input / Display)
     C     ScreenFlow    TAG
     C                   EVAL      ValErr = 1
     C                   EVAL      *INKE = *ON
     C                   EVAL      *IN70 = *ON
 
     C                   DOW       *INKL = *OFF and ValErr = 1
     C                             and *INKC = *OFF and *INKJ = *OFF
 
     C                   IF        *INKE = *ON
      ** Retrieve original data (Database / Default)
     C                   EXSR      RtvDetails
     C                   EVAL      *INKE = *OFF
     C                   ENDIF
 
     C                   EXSR      DspDetails
     C                   EXSR      RstInd
 
     C                   IF        *INKC = *OFF and *INKL = *OFF
     C                   EXSR      ValDetails
     C                   ENDIF
 
     C                   ENDDO
 
      ** Apply Input/Updates to Database, if any. Recycle screens for E and D
     C                   IF        *INKC = *OFF and *INKL = *OFF
 
     C                   IF        Actn = 'E'
     C                             or (Actn = 'D' and *INKJ = *OFF)
     C                   GOTO      Screenflow
     C                   ENDIF
 
     C                   EXSR      WriteUpd
 
      ** Send report to 'SD000200'
     C
     C                   MOVEL     'SD000200'    ZAPGM
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0312'     ZAMSID
     C                   EVAL      ZAMSDA = DCCODE + Action
     C                   EXSR      ZASNMS
 
     C                   ENDIF
 
     C                   IF        *INKC = *ON
     C                   EVAL      RetCode = 'Exit'
     C                   ENDIF
 
     C     EndPgm        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Init - Initialise screen header data                          *
      *                                                               *
      *****************************************************************
      *
     C     Init          BEGSR
     C                   EVAL      ZAPGM = PSProcName
     C                   EVAL      SPGM = PSProcName
     C                   EVAL      DJOB = PSJobName
     C                   EVAL      DCUSR = PSUser
     C                   EVAL      DCACTN = Actn
     C                   EVAL      DCCODE = ClsCode
     C                   IF        Mode = '*MAINT'
     C                   EVAL      *IN74 = *ON
     C                   ELSEIF    Mode = '*SELECT'
     C                   EVAL      *IN75 = *ON
     C                   ELSEIF    Mode = '*ENQRY'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
 
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
     C     InitE         ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * InpValCode - Check classification code for Insert             *
      *                                                               *
      *****************************************************************
      *
     C     InpValCode    BEGSR
     C                   EVAL      ValErr = 1
 
     C                   DOW       ValErr = 1
     C                             and *INKL = *OFF
     C                             and *INKC = *OFF
     C                   WRITE     SD000201F0
     C                   EXFMT     SD000201D0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   EXSR      ValClsCode
     C                   ENDDO
 
     C     InpValCodeE   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * ValClsCode - Check classification code                        *
      *                                                               *
      *****************************************************************
      *
     C     ValClsCode    BEGSR
 
      ** Classification Code should not be blank.
     C                   IF        %len(%trim(DCCODE)) <  1
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0309'     ZAMSID
     C                   MOVEL     DCCODE        ZAMSDA
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValClsCodeE
     C                   ENDIF
 
      ** Classification Code should not be *ALL.
     C                   IF        DCCODE = '*ALL'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0314'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValClsCodeE
     C                   ENDIF
 
     C     DCCODE        CHAIN     FCLSU
      ** Code should not already exists for Insert
     C                   IF        Actn = 'I'
     C
     C                   IF        %FOUND = '1'
     C
     C                   IF        FCRECI <> '*'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0310'     ZAMSID
     C                   MOVEL     DCCODE        ZAMSDA
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValClsCodeE
      ** Insert for Previously Deleted
     C                   ELSE
     C                   EVAL      ReUseCode = 'Y'
     C                   ENDIF
     C                   ENDIF
      ** Code is not deleted for Amend/Delete
      ** Skip loading for amend/delete if record is deleted
     C*                  ELSEIF    Actn <> 'E' and FCRECI = '*'
     C*                  EXSR      DelNotice
     C*                  GOTO      ValClsCodeE
     C*                  ENDIF
 
     C                   ENDIF
 
     C                   EVAL      ValErr = 0
     C
     C     ValClsCodeE   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * RstInd - Resets display file indicators                       *
      *                                                               *
      *****************************************************************
      *
     C     RstInd        BEGSR
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN13 = *OFF
     C                   EVAL      *IN14 = *OFF
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN17 = *OFF
     C                   EVAL      *IN18 = *OFF
     C                   EVAL      *IN19 = *OFF
     C*                  EVAL      *IN71 = *OFF
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * DspDetails - Display fields for user selected action          *
      *                                                               *
      *****************************************************************
      *
     C     DspDetails    BEGSR
     C                   SELECT
     C                   WHEN      Actn = 'I'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      Action = 'created'
     C                   WHEN      Actn = 'A'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      Action = 'updated'
     C                   WHEN      Actn = 'D'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   EVAL      *IN72 = *ON
     C                   EVAL      Action = 'deleted'
     C                   WHEN      Actn = 'E'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   EVAL      *IN73 = *ON
     C                   ENDSL
     C
     C                   WRITE     SD000201F0
     C                   WRITE     SD000201D0
     C                   EXFMT     SD000201D1
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
 
     C     DspDetailsE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * RtvDetails - Retrieve details for user update/enquiry/delete  *
      *                                                               *
      *****************************************************************
      *
     C     RtvDetails    BEGSR
 
     C                   IF        Actn <> 'I'
     C     DCCODE        CHAIN     FCLSU
 
     C                   IF        ScrLvl = 1
      ** Basic Details
     C                   EVAL      DCDESC = FCDESC
     C                   EVAL      DCUSIA = FCUSIA
     C                   ENDIF
 
     C                   ENDIF
 
     C     RtvDetailsE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDetails - Validates details from user input/amendment      *
      *                                                               *
      *****************************************************************
      *
     C     ValDetails    BEGSR
     C                   EVAL      ValErr = 0
      ** Classification Description
      ** Allow US Indicia Flag
     C                   IF        DCUSIA <> 'Y' and DCUSIA <> 'N'
     C                   EVAL      *IN19 = *ON
     C                   EVAL      ValErr = 1
 
     C                   MOVEL     'USS0311'     ZAMSID
     C                   EVAL      ZAMSDA = 'US Indicia Allowed indicator'
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValDetailsE
     C                   ENDIF
     C     ValDetailsE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteUpd - Writes/Updates necessary details on SDFATCPD       *
      *                                                               *
      *****************************************************************
      *
     C     WriteUpd      BEGSR
 
      ** Basic Details
      *
     C                   EVAL      FCRECI = 'D'
     C                   EVAL      FCCODE = DCCODE
     C                   EVAL      FCDESC = DCDESC
     C                   EVAL      FCUSIA = DCUSIA
     C                   EVAL      FCLCUS = DCUSR
     C                   EVAL      FCLCTP = Actn
     C                   EVAL      FCLCDT = BJRDNB
     C                   EVAL      FCLCTS = %timestamp()
      **
     C                   IF        Actn = 'I' and ReUseCode = 'Y'
     C                   EVAL      Actn = 'A'
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      Actn = 'I'
      *
      ** Create new record
      *
     C**********         WRITE     SDFATCD0                                                MD036917A
     C                   WRITE     FCLSU                                                   MD036917A
      ** Update existing / Reuse
     C                   WHEN      Actn = 'A'
     C                   UPDATE    FCLSU
      *
      ** Flag-Delete
      *
     C                   WHEN      Actn = 'D'
     C                   EVAL      FCRECI = '*'
     C                   UPDATE    FCLSU
 
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrMsgQue - Clear program message queue                       *
      *                                                               *
      *****************************************************************
      *
     C     ClrMsgQue     BEGSR
 
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM                          Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message Id
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type
      *
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
